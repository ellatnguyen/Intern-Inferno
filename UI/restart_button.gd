extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_restart_pressed():
	print("RESTART BUTTON PRESSED")
	get_tree().change_scene_to_file("res://Map.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_restart_pressed()

func _on_esc_pressed():
	print("ESC BUTTON PRESSED")
	get_tree().change_scene_to_file("res://StartandCutsceneScreen.tscn")
