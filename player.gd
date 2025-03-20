extends CharacterBody2D

@export var inv: Inv
@export var speed: float = 200  # Movement speed in pixels per second

func _process(delta):
	var direction = Vector2.ZERO  # Initialize movement direction

	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	direction = direction.normalized()  # Normalize to prevent faster diagonal movement
	velocity = direction * speed
	move_and_slide()
	
func collect(item):
	inv.insert(item)
