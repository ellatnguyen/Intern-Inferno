extends StaticBody2D

@export var possible_items: Array[Resource] # Array of InvItem resources (e.g., [coin.tres, medkit.tres, etc.])
var player = null
var used = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

var player_near = false

func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		player = body

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null

func _input(event):
	if event.is_action_pressed("interact") and player_near and not used:
		used = true
		shake_machine()
		drop_random_item()

func shake_machine():
	$AnimatedSprite2D.play("shake")  # Add a "shake" animation in your AnimationPlayer

func drop_random_item():
	if possible_items.is_empty():
		return
	var rand_index = randi() % possible_items.size()
	var selected_item = possible_items[rand_index]
	player.collect(selected_item)
