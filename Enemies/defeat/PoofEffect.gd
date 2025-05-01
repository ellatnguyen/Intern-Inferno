extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.scale = Vector2(1.5, 1.3)
	sprite.play("poof")
	await sprite.animation_finished
	queue_free()
