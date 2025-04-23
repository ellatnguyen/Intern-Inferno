#extends Node
#
#var current_enemy: Node = null
#var battle_ui: Node = null
#
#func start_battle_with(enemy: Node):
	#current_enemy = enemy
	#print("GAMEMANAGER Starting battle with:", current_enemy.name)
#
	#if battle_ui:
		#print("GAMEMANAGER BATTLE UI FOUND")
		#battle_ui.visible = true
		#battle_ui.start_battle_with(enemy)
#
#func _ready():
	## Hide the UI on startup
	#if battle_ui:
		#battle_ui.visible = false

# GameManager.gd
extends Node

var current_enemy: Node = null
