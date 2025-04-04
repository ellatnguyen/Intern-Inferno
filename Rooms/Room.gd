extends Node2D
class_name DungeonRoom

@export var boss_room: bool = false

var num_enemies: int

@onready var tilemap: TileMap = get_node("TileMap2")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	pass

func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()


func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		print(tilemap.local_to_map(entry_position.position))
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position), 1, Vector2i.ZERO)
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 2, Vector2i.ZERO)



func _on_PlayerDetector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	_open_doors()
