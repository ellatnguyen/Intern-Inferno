# imp_enemy.gd
extends "res://Enemies/base_enemy.gd"

func _ready():
	stats = {
		"PER_DMG": 2,
		"INT_DMG": 1,
	}
	dialogue_file_path = "res://Enemies/Dialogue/old_lady_spider.txt"
	super._ready()
	
	dialogue_sprite = preload("res://Enemies/DialogueBattleSprites/spider.png")
