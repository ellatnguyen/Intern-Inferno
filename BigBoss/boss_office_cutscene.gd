extends Control

@onready var boss_text: Label = $Panel/BossText
@onready var continue_button: Button = $Panel/ContinueButton

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	##get_tree().change_scene_to_file("res://mrboss.tscn")  # Load next scene
	#TransitionManager.fade_to_scene("res://BigBoss/mrboss.tscn")
	pass
