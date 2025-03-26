extends Sprite2D
#CHECK IF WE NEED ANY THING PAUSED IN THE GAME WHEN INVENTORY IS OPENED
#likely not since the productivity meter will always go down but doesn't hurt to ask
@export var closed_texture: Texture2D #closed clipboarddd
@export var open_texture: Texture2D # the open clipboard ig

var is_open = false

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_clipboard()

func toggle_clipboard():
	#if open and click 'i' then clipboard closes  :D yayayya
	is_open= !is_open #if closed and you click 'i' then clipboard open.
	
	texture = open_texture if is_open else closed_texture
