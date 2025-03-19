extends Control
func _input(event):
	if event.is_action_pressed("interact"):
		queue_free() #remove UI when pressing E
