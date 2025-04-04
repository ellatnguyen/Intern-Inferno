extends Character

const DUST_SCENE: PackedScene = preload("res://Characters/Player/Dust.tscn")

enum {UP, DOWN}

@onready var parent: Node2D = get_parent()
@onready var dust_position: Marker2D = get_node("DustPosition")


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	get_input()

	# Flip character based on movement direction
	if mov_direction.x > 0:
		animated_sprite.flip_h = false
	elif mov_direction.x < 0:
		animated_sprite.flip_h = true

func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP

func spawn_dust() -> void:
	var dust: Sprite2D = DUST_SCENE.instantiate()
	dust.position = dust_position.global_position
	parent.get_child(get_index() - 1).add_sibling(dust)


func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false
