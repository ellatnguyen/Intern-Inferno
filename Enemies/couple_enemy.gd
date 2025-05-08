# imp_enemy.gd
extends "res://Enemies/base_enemy.gd"

func _ready():
	stats = {
		"PER_DMG": 2,
		"INT_DMG": 2,
	}
	dialogue_file_path = "res://Enemies/Dialogue/couple_dialogue.txt"
	super._ready()
	
	dialogue_sprite = preload("res://Enemies/DialogueBattleSprites/couple.png")
