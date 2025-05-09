# PlayerFSM.gd

extends Node
class_name PlayerFSM

var states := {
	"idle": 0,
	"move": 1,
}
var state: int = -1
var previous_state: int = -1

var player
var animated_sprite  # Changed from animation_player

func init(p, sprite):
	player = p
	animated_sprite = sprite  # Use animated_sprite instead
	set_state(states.idle)

func _physics_process(delta: float) -> void:
	if state != -1:
		_state_logic(delta)
		var transition = _get_transition()
		if transition != -1 and transition != state:
			set_state(transition)

func _state_logic(_delta: float) -> void:
	if state in [states.idle, states.move]:
		player.get_input()
		player.move_player()
		
		# Update animation based on movement direction
		if state == states.move:
			update_movement_animation()

func update_movement_animation() -> void:
	# Get the dominant direction
	var dir = player.mov_direction
	
	if dir.length() > 0.1:
		if abs(dir.y) > abs(dir.x):
			# Vertical movement is dominant
			if dir.y > 0:
				# Moving down/forward
				if animated_sprite.animation != "forward":
					animated_sprite.play("forward")
			else:
				# Moving up/backward
				if animated_sprite.animation != "move":
					animated_sprite.play("move")
		else:
			# Horizontal movement is dominant
			if animated_sprite.animation != "move":
				animated_sprite.play("move")

func _get_transition() -> int:
	match state:
		states.idle:
			if player.velocity.length() > 15:
				return states.move
		states.move:
			if player.velocity.length() < 5:
				return states.idle
	return -1

func set_state(new_state: int) -> void:
	_exit_state(state)
	previous_state = state
	state = new_state
	_enter_state(previous_state, state)

func _enter_state(_prev: int, new_state: int) -> void:
	match new_state:
		states.idle:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
			player.scale = Vector2(1, 1)  # Normal scale
		states.move:
			# Initial animation will be set in update_movement_animation()
			animated_sprite.play("move")
			player.scale = Vector2(2.5, 2.5)  # 2x scale

func _exit_state(_state_exited: int) -> void:
	pass
