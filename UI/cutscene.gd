extends Control

@onready var slideshow = $Slideshow
var current_frame := 0

func _ready():
	slideshow.animation = "cutscene"
	slideshow.frame = current_frame
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		current_frame += 1
		if current_frame < slideshow.sprite_frames.get_frame_count("cutscene"):
			slideshow.frame = current_frame
		else:
			await SceneTransition.change_scene_with_fade("res://Map.tscn")
