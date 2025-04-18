extends Node2D

@onready var dialogue_window = $DialogueWindow
@onready var player = $Player
@onready var npc = $NPC

var battle = preload("res://Battle Scene/Battle.tscn") # THIS WILL BE USED TO SWITCH OVER TO BATTLE SCENE (TBA)
var can_interact = false  # Tracks if the player is in range of the Goblin

func _ready() -> void:
	_hide_dialogue_window()  # Hide everything initially
	npc.connect("player_near", Callable(self, "_on_npc_player_near"))  # Connect Goblin signal to Game

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):  # 'E' should be mapped to 'interact' in InputMap
		_show_dialogue_window()  # Show everything when 'E' is pressed
		
		# THIS WILL BE USED TO SWITCH OVER TO BATTLE SCENE (TBA)
		#var battleTemp = battle.instantiate()
		#get_parent().addchild(battleTemp)
		#queue_free()

func _on_npc_player_near(state: bool) -> void:
	can_interact = state
	if state:
		print("Player is near NPC. Press 'E' to interact.")  # Debugging line
	else:
		print("Player left NPC.")  # Debugging line

func _hide_dialogue_window() -> void:
	dialogue_window.visible = false  # Hide the main window
	for child in dialogue_window.get_children():
		child.visible = false  # Hide all children (CanvasLayer, buttons, etc.)

func _show_dialogue_window() -> void:
	dialogue_window.visible = true  # Show the main window
	for child in dialogue_window.get_children():
		child.visible = true  # Show all children (CanvasLayer, buttons, etc.)
