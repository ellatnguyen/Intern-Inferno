extends StaticBody2D 

@export var vending_ui: PackedScene  

var player_near = false  # Track if player is in interaction range

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player": 
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
