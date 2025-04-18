extends StaticBody2D

func open() -> void:
	queue_free()
	self.visible = false
