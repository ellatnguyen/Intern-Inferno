extends StaticBody2D  # StaticBody2D ensures the player can't walk through it

@export var vending_ui: PackedScene  # Assign vending UI scene in Inspector

var player_near = false  # Track if player is in interaction range

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":  # Ensure Player is the correct node name
		player_near = true

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		open_vending_machine()

func open_vending_machine():
	var vending_screen = vending_ui.instantiate()
	get_tree().current_scene.add_child(vending_screen)
