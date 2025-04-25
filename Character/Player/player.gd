# Player.gd

extends CharacterBody2D

const FRICTION: float = 0.15
const ACCELERATION: int = 40
const MAX_SPEED: int = 100

@export var inv: Inv
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fsm: PlayerFSM = $PlayerFSM
@onready var camera_main: Camera2D = $Camera2D

var current_enemy: BaseEnemy = null
var mov_direction: Vector2 = Vector2.ZERO
var controls_enabled := true

func _ready() -> void:
	add_to_group("player")
	fsm.init(self, animation_player)

func _physics_process(_delta: float) -> void:
	if not controls_enabled:
		return
		
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

func _on_enemy_player_near(state: bool, enemy: BaseEnemy) -> void:
	if state:
		current_enemy = enemy
	else:
		current_enemy = null
		
func _unhandled_input(event):
	if not controls_enabled:
		return
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact") and current_enemy:
		#current_enemy.start_battle()
func collect(item):
	if inv==null:
		print("Inventory not assigned")
		return
	print("adding item to inventory")
	inv.insert(item)
