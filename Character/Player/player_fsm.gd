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
var animation_player

func init(p, anim):
	player = p
	animation_player = anim
	set_state(states.idle)

func _physics_process(delta: float) -> void:
	if state != -1:
		_state_logic(delta)
		var transition = _get_transition()
		if transition != -1:
			set_state(transition)

func _state_logic(_delta: float) -> void:
	if state in [states.idle, states.move]:
		player.get_input()
		player.move_player()

func _get_transition() -> int:
	match state:
		states.idle:
			if player.velocity.length() > 10:
				return states.move
		states.move:
			if player.velocity.length() < 10:
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
			animation_player.play("idle")
		states.move:
			animation_player.play("move")

func _exit_state(_state_exited: int) -> void:
	pass
