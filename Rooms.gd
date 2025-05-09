extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn")]

const INTERMEDIATE_ROOMS: Array = [
	preload("res://Rooms/Room0.tscn"), preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn"), preload("res://Rooms/Room3.tscn"), 
	preload("res://Rooms/Room4.tscn"), preload("res://Rooms/Room5.tscn"),
	preload("res://Rooms/Room6.tscn"), preload("res://Rooms/Room7.tscn")]
  
const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 14
const RIGHT_WALL_TILE_INDEX: int = 5
const LEFT_WALL_TILE_INDEX: int = 6
const WALL_TILE_INDEX: int = 4

var room_positions := {}
var previous_directions := [] # Tracks the last two directions to prevent 3 in a row
var rooms_spawned := 0
var room_connections := {} # Tracks which rooms are connected and in which directions

@export var num_levels: int = 20
@export var min_corridor_length: int = 5
@export var max_corridor_length: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	SavedData.num_floor += 1
	_spawn_rooms()

func _spawn_rooms() -> void:
	var previous_room: Node2D = null
	var previous_direction: Vector2 = Vector2.ZERO
	var room: Node2D
	var room_position: Vector2

	for i in range(num_levels):
		if i == 0:
			# First room - spawn room (must have north door only)
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
			room_position = Vector2.ZERO
			rooms_spawned += 1
			
			# For spawn room, ensure only north is open (north wall should be invisible and have no collision)
			_set_wall_visibility(room, false, true, true, true)
			
			# Make sure the hallway is visible for the spawn room
			var north_hallway = room.get_node_or_null("NorthHallway")
			if north_hallway:
				north_hallway.visible = true
				
			# Record connection
			room_connections[room_position] = {"north": true}
		else:
			# For the second room (first after spawn), force north direction
			if rooms_spawned == 1:
				previous_direction = Vector2.UP
			else:
				# For subsequent rooms, get valid directions
				var valid_directions = _get_valid_directions(previous_direction)
				previous_direction = valid_directions[randi() % valid_directions.size()]
			
			# Update direction history
			_update_direction_history(previous_direction)
			
			# Spawn intermediate room
			room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
			
			# Calculate position based on direction
			var prev_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var prev_room_size = prev_room_tilemap.get_used_rect().size * TILE_SIZE
			
			match previous_direction:
				Vector2.UP:
					room_position = Vector2(
						room_position.x,
						room_position.y - prev_room_size.y
					)
				Vector2.RIGHT:
					room_position = Vector2(
						room_position.x + prev_room_size.x,
						room_position.y
					)
				Vector2.LEFT:
					room_position = Vector2(
						room_position.x - prev_room_size.x,
						room_position.y
					)
			
			# Initialize room connection data
			if not room_connections.has(room_position):
				room_connections[room_position] = {}
			if not room_connections.has(previous_room.position):
				room_connections[previous_room.position] = {}
				
			# Connect with corridor and handle hallways/walls
			var door = _get_door_in_direction(previous_room, previous_direction)
			if door:
				var corridor_length = randi() % (max_corridor_length - min_corridor_length + 1) + min_corridor_length
				
				match previous_direction:
					Vector2.UP:
						_generate_vertical_corridor(previous_room.get_node("TileMap"), door, corridor_length)
						# For north connection (previous room to new room above it)
						var north_hallway = previous_room.get_node_or_null("NorthHallway")
						if north_hallway:
							north_hallway.visible = true
						var north_wall = previous_room.get_node_or_null("NorthWall")
						if north_wall:
							north_wall.visible = false
							_toggle_wall_collision(previous_room, "North", false)
						
						# Hide south wall in new room (since it connects to room below)
						var south_wall = room.get_node_or_null("SouthWall")
						if south_wall:
							south_wall.visible = false
							_toggle_wall_collision(room, "South", false)
						
						# Record connections
						room_connections[previous_room.position]["north"] = true
						room_connections[room_position]["south"] = true
						
					Vector2.RIGHT:
						_generate_horizontal_corridor(previous_room.get_node("TileMap"), door, corridor_length, true)
						# Previous room (east exit)
						var east_hallway = previous_room.get_node_or_null("EastHallway")
						if east_hallway:
							east_hallway.visible = true
						var east_wall = previous_room.get_node_or_null("EastWall")
						if east_wall:
							east_wall.visible = false
							_toggle_wall_collision(previous_room, "East", false)
						
						# New room (west entrance)
						var west_hallway = room.get_node_or_null("WestHallway")
						if west_hallway:
							west_hallway.visible = true
						var west_wall = room.get_node_or_null("WestWall")
						if west_wall:
							west_wall.visible = false
							_toggle_wall_collision(room, "West", false)
							
						# Record connections
						room_connections[previous_room.position]["east"] = true
						room_connections[room_position]["west"] = true
						
					Vector2.LEFT:
						_generate_horizontal_corridor(previous_room.get_node("TileMap"), door, corridor_length, false)
						# Previous room (west exit)
						var west_hallway = previous_room.get_node_or_null("WestHallway")
						if west_hallway:
							west_hallway.visible = true
						var west_wall = previous_room.get_node_or_null("WestWall")
						if west_wall:
							west_wall.visible = false
							_toggle_wall_collision(previous_room, "West", false)
						
						# New room (east entrance)
						var east_hallway = room.get_node_or_null("EastHallway")
						if east_hallway:
							east_hallway.visible = true
						var east_wall = room.get_node_or_null("EastWall")
						if east_wall:
							east_wall.visible = false
							_toggle_wall_collision(room, "East", false)
							
						# Record connections
						room_connections[previous_room.position]["west"] = true
						room_connections[room_position]["east"] = true
				
				# Position the new room's entrance correctly
				var entrance_direction = -previous_direction
				var entrance = _get_entrance_in_direction(room, entrance_direction)
				if entrance:
					var room_tilemap: TileMap = room.get_node("TileMap")
					var entrance_pos = room_tilemap.map_to_local(room_tilemap.local_to_map(entrance.position))
					var offset = entrance_pos - entrance.position
					room.position -= offset

			rooms_spawned += 1

		# Position and add the room
		room.position = room_position
		add_child(room)
		
		# Apply wall visibility based on connections
		_update_room_walls(room)
		
		previous_room = room
		room_positions[room_position] = room

# New function to update wall visibility based on connections
func _update_room_walls(room: Node2D) -> void:
	var pos = room.position
	
	# Default - all walls visible
	var show_north = true
	var show_east = true
	var show_west = true 
	var show_south = true
	
	# Check connections
	if room_connections.has(pos):
		if room_connections[pos].get("north", false):
			show_north = false
		if room_connections[pos].get("east", false):
			show_east = false
		if room_connections[pos].get("west", false):
			show_west = false
		if room_connections[pos].get("south", false):
			show_south = false
			
	# Special case for spawn room - Always ensure north is open
	if pos == Vector2.ZERO:
		show_north = false
		
	# Update wall visibility
	if room.has_node("NorthWall"):
		room.get_node("NorthWall").visible = show_north
		_toggle_wall_collision(room, "North", show_north)
		
	if room.has_node("EastWall"):
		room.get_node("EastWall").visible = show_east
		_toggle_wall_collision(room, "East", show_east)
		
	if room.has_node("WestWall"):
		room.get_node("WestWall").visible = show_west
		_toggle_wall_collision(room, "West", show_west)
		
	if room.has_node("SouthWall"):
		room.get_node("SouthWall").visible = show_south
		_toggle_wall_collision(room, "South", show_south)
		
	# Update hallway visibility based on connections
	if room.has_node("NorthHallway"):
		room.get_node("NorthHallway").visible = not show_north
	if room.has_node("EastHallway"):
		room.get_node("EastHallway").visible = not show_east
	if room.has_node("WestHallway"):
		room.get_node("WestHallway").visible = not show_west
	if room.has_node("SouthHallway"):
		room.get_node("SouthHallway").visible = not show_south

# Original helper function to enable/disable wall collision
func _toggle_wall_collision(room: Node2D, wall_direction: String, enabled: bool) -> void:
	var wall_body = room.get_node_or_null(wall_direction + "WallBody")
	if wall_body:
		for child in wall_body.get_children():
			if child is CollisionShape2D:
				child.disabled = not enabled

func _set_wall_visibility(room: Node2D, north: bool, east: bool, west: bool, south: bool) -> void:
	# North Wall
	if room.has_node("NorthWall"):
		room.get_node("NorthWall").visible = north
		_toggle_wall_collision(room, "North", north)
		
	# East Wall
	if room.has_node("EastWall"):
		room.get_node("EastWall").visible = east
		_toggle_wall_collision(room, "East", east)
		
	# West Wall
	if room.has_node("WestWall"):
		room.get_node("WestWall").visible = west
		_toggle_wall_collision(room, "West", west)
		
	# South Wall
	if room.has_node("SouthWall"):
		room.get_node("SouthWall").visible = south
		_toggle_wall_collision(room, "South", south)

func _get_valid_directions(last_direction: Vector2) -> Array:
	var valid_directions = []
	
	# Always allow north, east, west (except special cases below)
	valid_directions.append(Vector2.UP)
	valid_directions.append(Vector2.RIGHT)
	valid_directions.append(Vector2.LEFT)
	
	# Remove directions that would cause 3 in a row
	if previous_directions.size() >= 2:
		if previous_directions[0] == previous_directions[1]:
			valid_directions.erase(previous_directions[0])
	
	# Remove opposite of last direction to prevent backtracking
	if last_direction != Vector2.ZERO:
		valid_directions.erase(-last_direction)
	
	return valid_directions

func _update_direction_history(direction: Vector2):
	previous_directions.append(direction)
	if previous_directions.size() > 2:
		previous_directions.pop_front()

func _generate_vertical_corridor(tilemap: TileMap, door: Node2D, height: int) -> void:
	var door_tile_pos := tilemap.local_to_map(door.position)
	
	# Show north hallway in the previous room (since we're going up)
	var north_hallway = tilemap.get_parent().get_node_or_null("NorthHallway")
	if north_hallway:
		north_hallway.visible = true
	
	for y in height:
		# Floor tiles
		tilemap.set_cell(0, door_tile_pos + Vector2i(-1, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
		tilemap.set_cell(0, door_tile_pos + Vector2i(0, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)

func _generate_horizontal_corridor(tilemap: TileMap, door: Node2D, length: int, right_direction: bool) -> void:
	var door_tile_pos := tilemap.local_to_map(door.position)
	var direction := 1 if right_direction else -1
	
	# Show appropriate hallway based on direction
	if right_direction:
		var east_hallway = tilemap.get_parent().get_node_or_null("EastHallway")
		if east_hallway:
			east_hallway.visible = true
	else:
		var west_hallway = tilemap.get_parent().get_node_or_null("WestHallway")
		if west_hallway:
			west_hallway.visible = true
	
	for x in length:
		# Floor tiles
		tilemap.set_cell(0, door_tile_pos + Vector2i(direction * x, 0), FLOOR_TILE_INDEX, Vector2i.ZERO)
		tilemap.set_cell(0, door_tile_pos + Vector2i(direction * x, -1), FLOOR_TILE_INDEX, Vector2i.ZERO)	

func _get_door_in_direction(room: Node2D, direction: Vector2) -> Node2D:
	var door_container = room.get_node("Doors")
	if direction == Vector2.UP:  # North
		return door_container.get_node_or_null("DoorNorth")
	elif direction == Vector2.RIGHT:  # East
		return door_container.get_node_or_null("DoorEast")
	elif direction == Vector2.LEFT:  # West
		return door_container.get_node_or_null("DoorWest")
	return null

func _get_entrance_in_direction(room: Node2D, direction: Vector2) -> Node2D:
	var entrance_container = room.get_node("Entrance")
	if direction == Vector2.DOWN:  # South
		return entrance_container.get_node_or_null("PositionSouth")
	elif direction == Vector2.RIGHT:  # East
		return entrance_container.get_node_or_null("PositionEast")
	elif direction == Vector2.LEFT:  # West
		return entrance_container.get_node_or_null("PositionWest")
	return null
