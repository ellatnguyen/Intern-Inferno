extends Control

@onready var dialogue_text = $DialogueBoxesWithDarkenedBackground/DialogueText
@onready var int_button = $INT_Button
@onready var per_button = $PER_Button
@onready var leave_button = $LEAVE_Button
@onready var health_bar = $"EnemyPortrait/ComplianceBar"
@onready var enemy_portrait = $EnemyPortrait
@onready var productivity_bar = get_node("/root/Game/TimerUI/Container/ProductivityBar")  # Adjust path as needed

var battle_ended_
