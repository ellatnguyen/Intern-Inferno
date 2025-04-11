extends Control

@onready var dialogue_text = $CanvasLayer/DialogueText
@onready var int_button = $CanvasLayer/INT_Button
@onready var per_button = $CanvasLayer/PER_Button
@onready var leave_button = $CanvasLayer/LEAVE_Button
@onready var dialogue_window = $DialogueWindow
@onready var health_bar = $"CanvasLayer/PrototypeEnemy/ComplianceBar"

var current_int_line = 0  # Tracks the current line for INT dialogue
var current_per_line = 0  # Tracks the current line for PER dialogue

var per_dialogue = []
var int_dialogue = []
var current_dialogue = []

const MAX_HEALTH = 11  # Max frame index
var enemy_health = MAX_HEALTH  # Start at full health

func _ready():
	if int_button == null or per_button == null:
		print("Error: One or more buttons not found.")
		return
	
	print("Buttons found successfully!")

	int_button.pressed.connect(_on_int_button_pressed)  
	per_button.pressed.connect(_on_per_button_pressed)  

	var file = FileAccess.open("res://dialogues.txt", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		parse_dialogue(text)

	update_dialogue()
	update_health_bar()

func parse_dialogue(dialogue_content):
	var lines = dialogue_content.split("\n")
	var current_type = ""

	for line in lines:
		if line == "PER":
			current_type = "PER"
		elif line == "INT":
			current_type = "INT"
		elif line.strip_edges() != "":
			if current_type == "PER":
				per_dialogue.append(line.strip_edges())  # Add to PER dialogue
			elif current_type == "INT":
				int_dialogue.append(line.strip_edges())  # Add to INT dialogue

	# Debugging output
	print("INT Dialogue:", int_dialogue)
	print("PER Dialogue:", per_dialogue)

func update_dialogue():
	if current_dialogue.size() > 0:
		if current_dialogue == int_dialogue:
			if current_int_line < int_dialogue.size():
				dialogue_text.text = int_dialogue[current_int_line]
			else:
				dialogue_text.text = "End of INT dialogue."
		elif current_dialogue == per_dialogue:
			if current_per_line < per_dialogue.size():
				dialogue_text.text = per_dialogue[current_per_line]
			else:
				dialogue_text.text = "End of PER dialogue."
	else:
		dialogue_text.text = "No dialogue available."

func _on_int_button_pressed():
	print("INT Button Pressed!")
	current_dialogue = int_dialogue
	current_int_line += 1
	if current_int_line < int_dialogue.size():
		update_dialogue()
		decrease_enemy_health()  # Reduce health
	else:
		dialogue_text.text = "End of INT dialogue."  # End of INT section

func _on_per_button_pressed():
	print("PER Button Pressed!")
	current_dialogue = per_dialogue
	current_per_line += 1
	if current_per_line < per_dialogue.size():
		update_dialogue()
		decrease_enemy_health()  # Reduce health
	else:
		dialogue_text.text = "End of PER dialogue."  # End of PER section

func decrease_enemy_health():
	if enemy_health > 0:
		enemy_health -= 1
		update_health_bar()

		if enemy_health == 0:
			end_battle()  # Trigger battle end when health reaches 0

func update_health_bar():
	if health_bar:
		health_bar.frame = enemy_health  # Set the correct frame based on health
		print("Enemy Health:", enemy_health)  # Debugging output
	else:
		print("Error: Health bar not found.")

func end_battle():
	print("Battle Over!")  
	self.visible = false  
	for child in get_children():
		child.visible = false  

func _on_leave_button_pressed():
	print("LEAVE Button Pressed!")  
	self.visible = false  
	for child in get_children():
		child.visible = false  
