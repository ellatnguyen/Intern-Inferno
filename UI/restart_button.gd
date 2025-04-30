extends Button

func _ready():
	pass

func _process(delta):
	pass

func _on_restart_pressed():
	print("RESTART BUTTON PRESSED")
	await SceneTransition.change_scene_with_fade("res://Map.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_restart_pressed()

func _on_esc_pressed():
	print("ESC BUTTON PRESSED")
	await SceneTransition.change_scene_with_fade("res://StartandCutsceneScreen.tscn")
