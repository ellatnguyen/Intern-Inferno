# rooms.gd
extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn")]
#const INTERMEDIATE_ROOMS: Array = [
	#preload("res://Rooms/Room0.tscn"), preload("res://Rooms/Room1.tscn"),
	#preload("res://Rooms/Room2.tscn"), preload("res://Rooms/Room3.tscn"), 
	#preload("res://Rooms/Room4.tscn"), preload("res://Rooms/Room5.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room5.tscn"),
preload("res://Rooms/Room6.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 14
const RIGHT_WALL_TILE_INDEX: int = 5
const LEFT_WALL_TILE_INDEX: int = 6
const WALL_TILE_INDEX: int = 4

var room_positions := {}
var previous_directions := [] # Tracks the last two directions to prevent 3 in a row
var rooms_spawned := 0

@export var num_levels: int = 7
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
			
			# Connect with corridor
			var door = _get_door_in_direction(previous_room, previous_direction)
			if door:
				var corridor_length = randi() % (max_corridor_length - min_corridor_length + 1) + min_corridor_length
				
				match previous_direction:
					Vector2.UP:
						_generate_vertical_corridor(previous_room.get_node("TileMap"), door, corridor_length)
					Vector2.RIGHT:
						_generate_horizontal_corridor(previous_room.get_node("TileMap"), door, corridor_length, true)
					Vector2.LEFT:
						_generate_horizontal_corridor(previous_room.get_node("TileMap"), door, corridor_length, false)
				
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
		previous_room = room
		room_positions[room_position] = room

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
# Corridor generation functions remain the same...
func _generate_vertical_corridor(tilemap: TileMap, door: Node2D, height: int) -> void:
	var door_tile_pos := tilemap.local_to_map(door.position)
	
	for y in height:
		# Floor tiles
		tilemap.set_cell(0, door_tile_pos + Vector2i(-1, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
		tilemap.set_cell(0, door_tile_pos + Vector2i(0, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
		

func _generate_horizontal_corridor(tilemap: TileMap, door: Node2D, length: int, right_direction: bool) -> void:
	var door_tile_pos := tilemap.local_to_map(door.position)
	var direction := 1 if right_direction else -1
	
	for x in length:
		# Floor tiles
		tilemap.set_cell(0, door_tile_pos + Vector2i(direction * x, 0), FLOOR_TILE_INDEX, Vector2i.ZERO)
		tilemap.set_cell(0, door_tile_pos + Vector2i(direction * x, -1), FLOOR_TILE_INDEX, Vector2i.ZERO)
		
# Helper functions remain the same...
func _get_door_in_direction(room: Node2D, direction: Vector2) -> Node2D:
	var door_container = room.get_node("Doors")
	if direction == Vector2.UP:  # North
		return door_container.get_node_or_null("Door")
	elif direction == Vector2.RIGHT:  # East
		return door_container.get_node_or_null("Door2")
	elif direction == Vector2.LEFT:  # West
		return door_container.get_node_or_null("Door3")
	return null

func _get_entrance_in_direction(room: Node2D, direction: Vector2) -> Node2D:
	var entrance_container = room.get_node("Entrance")
	if direction == Vector2.DOWN:  # South
		return entrance_container.get_node_or_null("Position2D2")
	elif direction == Vector2.RIGHT:  # East
		return entrance_container.get_node_or_null("Position2D3")
	elif direction == Vector2.LEFT:  # West
		return entrance_container.get_node_or_null("Position2D4")
	return null
