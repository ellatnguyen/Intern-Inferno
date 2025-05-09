extends Node2D

@onready var endscene = $EndScene

func _ready():
	endscene.play()
	await endscene.animation_finished
	await SceneTransition.change_scene_with_fade("res://UI/WinScreen.tscn")
