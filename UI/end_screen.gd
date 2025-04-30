extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_restart_button_pressed():
	print("RESTART BUTTON PRESSED")
	get_tree().change_scene_to_file("res://Map.tscn")

func _on_esc_button_pressed():
	print("ESC BUTTON PRESSED")
	get_tree().change_scene_to_file("res://UI/StartandCutsceneScreen.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_restart_button_pressed()
		
	if event.is_action_pressed("mainmenu"):
		_on_esc_button_pressed()
