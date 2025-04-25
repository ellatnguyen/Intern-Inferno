#extends Node2D
#
#
#func _init() -> void:
	#randomize()
#
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_focus_next"):
		#get_tree().paused = true


extends Node2D
# Map.gd

@onready var player = $Player
@onready var dialogue_battle_ui = $DialogueBattleUI/DialogueWindow  # Must already exist in the scene

var nearby_enemy: Node = null

func _init() -> void:
	randomize()

func _ready():
	# No need to reference GameManager if it's autoloaded
	nearby_enemy = null
	if dialogue_battle_ui:
		print("DialogueBattleUI node successfully referenced in Map.gd.")
	else:
		print("ERROR: DialogueBattleUI not found in Map.gd.")
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("player_near", Callable(self, "_on_enemy_player_near"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		get_tree().paused = true
	
	if event.is_action_pressed("interact") and is_instance_valid(nearby_enemy) and GameManager.in_battle == false:
		if nearby_enemy.has_method("is_player_near") and nearby_enemy.is_player_near():
			print("MAP.GD: Starting battle with:", nearby_enemy.name)
			dialogue_battle_ui.start_battle_with(nearby_enemy)
		else:
			print("MAP.GD: Tried to battle but player is not near enemy anymore.")
			nearby_enemy = null  # Clear it out just in case

func _on_enemy_player_near(state: bool, enemy: Node):
	if state:
		print("Player is near enemy:", enemy.name)
		nearby_enemy = enemy
	else:
		print("Player left enemy:", enemy.name)
		if nearby_enemy == enemy:
			nearby_enemy = null
	if not is_instance_valid(enemy):
		return
