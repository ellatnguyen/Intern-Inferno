# Player.gd

extends CharacterBody2D

const FRICTION: float = 0.15
const ACCELERATION: int = 40
const MAX_SPEED: int = 100

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fsm: PlayerFSM = $PlayerFSM
@onready var camera_main: Camera2D = $Camera2D

var mov_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("player")
	fsm.init(self, animation_player)

func _physics_process(_delta: float) -> void:
	fsm._physics_process(_delta)
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)

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

func move_player() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * ACCELERATION
	velocity = velocity.limit_length(MAX_SPEED)

func _process(_delta: float) -> void:
	if mov_direction.x > 0:
		animated_sprite.flip_h = true
	elif mov_direction.x < 0:
		animated_sprite.flip_h = false

func switch_camera() -> void:
	camera_main.position = position
	camera_main.current = true
