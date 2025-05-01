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
@onready var fahrenheit_timer: Timer = $FahrenheitTimer

var current_enemy: BaseEnemy = null
var mov_direction: Vector2 = Vector2.ZERO
var controls_enabled := true

var has_damage_boost :=false
var speed_multiplier :=1.0
var 	player_stats = {
		"PER_EXP": 0,
		"INT_EXP": 0,
		"PER_LVL": 1,
		"INT_LVL": 1
	}

func _ready() -> void:
	var inv_factory:=preload("res://inventory/new_inventory.gd")
	inv=inv_factory.create_inventory(3)
	print("created new inventory")
	player_stats = {
		"PER_EXP": 0,
		"INT_EXP": 0,
		"PER_LVL": 1,
		"INT_LVL": 1
	}
	
	add_to_group("player")
	fsm.init(self, animation_player)
	
	var inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if inventory_ui:
		inventory_ui.set_inventory(inv)
	fahrenheit_timer.timeout.connect(_on_fahrenheit_timer_timeout)

func _physics_process(_delta: float) -> void:
	if is_inventory_open():
		return  # Freeze player movement input only

	fsm._physics_process(_delta)
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)

func is_inventory_open() -> bool:
	var inv_ui = get_tree().get_first_node_in_group("inventory_ui")
	return inv_ui != null and inv_ui.is_open

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
	velocity += mov_direction * ACCELERATION * speed_multiplier
	velocity = velocity.limit_length(MAX_SPEED*speed_multiplier)

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

func update_levels() -> void:
	var per_exp = player_stats["PER_EXP"]
	var int_exp = player_stats["INT_EXP"]

	var new_per_level := 1
	if per_exp >= 20:
		new_per_level = 3
	elif per_exp >= 3:
		new_per_level = 2

	var new_int_level := 1
	if int_exp >= 20:
		new_int_level = 3
	elif int_exp >= 3:
		new_int_level = 2

	var old_per_level = player_stats["PER_LVL"]
	var old_int_level = player_stats["INT_LVL"]

	if new_per_level > old_per_level:
		print("PER Level Up! New Level: ", new_per_level)

	if new_int_level > old_int_level:
		print("INT Level Up! New Level: ", new_int_level)

	player_stats["PER_LVL"] = new_per_level
	player_stats["INT_LVL"] = new_int_level


func gain_per_exp(amount: int) -> void:
	player_stats["PER_EXP"] += amount
	update_levels()
	update_inventory_ui()

func gain_int_exp(amount: int) -> void:
	player_stats["INT_EXP"] += amount
	update_levels()
	update_inventory_ui()

func update_inventory_ui():
	var inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if inventory_ui:
		print("YIPEE Found inventory_ui group node:", inventory_ui.name)
		inventory_ui.update_level_display()
	else:
		print("...Inventory UI NOT FOUND!")
func _on_fahrenheit_timer_timeout():
	speed_multiplier = 1.0
	print("BOOO Fahrenheit effect has ended.")
