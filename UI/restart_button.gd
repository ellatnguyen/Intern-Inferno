extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_pressed():
	print("RESTART BUTTON PRESSED")
	get_tree().change_scene_to_file("res://Map.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_pressed()
