extends StaticBody2D

@export var item: InvItem
var player=null

var player_near = false  # Track if player is in interaction range

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player": 
		player_near = true
		player=body

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		player.collect(item)
