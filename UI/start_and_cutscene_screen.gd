extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_restart_button_pressed():
	print("RESTART BUTTON PRESSED")
	await SceneTransition.change_scene_with_fade("res://UI/Cutscene.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_on_restart_button_pressed()
