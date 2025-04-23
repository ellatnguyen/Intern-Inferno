# imp_enemy.gd
extends "res://Enemies/base_enemy.gd"

func _ready():
	stats = {
		"PER_DMG": 3,
		"INT_DMG": 1,
	}
	dialogue_file_path = "res://Enemies/Dialogue/imp_dialogue.txt"
	super._ready()
