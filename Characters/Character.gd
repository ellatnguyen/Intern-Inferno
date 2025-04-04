@icon("res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png")

extends CharacterBody2D
class_name Character

const FRICTION: float = 0.15

@export var accerelation: int = 40
@export var max_speed: int = 100

@export var flying: bool = false

@onready var state_machine: Node = get_node("FiniteStateMachine")
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var mov_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)


func move() -> void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * accerelation
	velocity = velocity.limit_length(max_speed)
