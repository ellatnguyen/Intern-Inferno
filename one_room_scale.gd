extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var image_size = texture.get_size()  # ← simpler, because you're on Sprite2D already
	scale = screen_size / image_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
