extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("poof")
	await sprite.animation_finished
	queue_free()
