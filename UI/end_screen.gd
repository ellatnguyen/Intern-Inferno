extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_restart_button_pressed():
	print("RESTART BUTTON PRESSED")
	await SceneTransition.change_scene_with_fade("res://Map.tscn")

func _on_esc_button_pressed():
	print("ESC BUTTON PRESSED")
	await SceneTransition.change_scene_with_fade("res://UI/StartScreen.tscn")
	WwiseManager.start_game()

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_restart_button_pressed()
		
	if event.is_action_pressed("mainmenu"):
		_on_esc_button_pressed()
