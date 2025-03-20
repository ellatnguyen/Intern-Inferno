extends Control

@export var closed_texture: Texture2D #closed clipboarddd
@export var open_texture: Texture2D # the open clipboard ig


var is_open = false

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible=true
	is_open=true
	
func close():
	visible=false
	is_open = false
