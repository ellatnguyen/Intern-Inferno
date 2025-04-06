extends CharacterBody2D

signal player_near(state)

@onready var interaction_area = $InteractionArea  # Assuming InteractionArea is of type Area2D

func _ready():
	if interaction_area:
		interaction_area.connect("body_entered", Callable(self, "_on_interaction_area_body_entered"))
		interaction_area.connect("body_exited", Callable(self, "_on_interaction_area_body_exited"))
		print("InteractionArea is connected!")  # Debugging
	else:
		print("ERROR: InteractionArea not found!")  # Debugging

# When a body enters the interaction area
func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):  # Check if the body is the player
		print("Player entered interaction area")  # Debugging
		emit_signal("player_near", true)  # Emit the signal
	else:
		print("Non-player body entered interaction area: " + body.name)  # Debugging

# When a body exits the interaction area
func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):  # Check if the body is the player
		print("Player left interaction area")  # Debugging
		emit_signal("player_near", false)  # Emit the signal
	else:
		print("Non-player body exited interaction area: " + body.name)  # Debugging
