extends Sprite2D

@export var closed_texture: Texture2D #closed clipboarddd
@export var open_texture: Texture2D # the open clipboard ig

var is_open = false

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_clipboard()

func toggle_clipboard():
	is_open= !is_open
	texture = open_texture if is_open else closed_texture
