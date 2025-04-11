extends CharacterBody2D

@export var inv: Inv
@export var speed: float = 200  # Movement speed in pixels per second
@onready var animated_sprite =$AnimatedSprite2D

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
	
	if direction.x<0:
		animated_sprite.flip_h=false
		animated_sprite.play("walk_left")
	elif direction.x>0:
		animated_sprite.flip_h = true
		animated_sprite.play("walk_left")
	elif direction.y<0:
		pass
		#animated_sprite.play("walk_up")
	elif direction.y>0:
		pass
		#animated_sprite.play("walk_down")
	else:
		animated_sprite.stop()
	
func collect(item):
	if inv==null:
		print("Inventory not assigned")
		return
	print("adding item to inventory")
	inv.insert(item)
