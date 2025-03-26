extends Control

# Declare variables for your buttons and label
@onready var dialogue_text = $CanvasLayer/DialogueText
@onready var int_button = $CanvasLayer/INT_Button
@onready var per_button = $CanvasLayer/PER_Button  # Ensure the correct name here

var current_line = 0
var per_dialogue = []
var int_dialogue = []
var current_dialogue = []

# Load the dialogue file
func _ready():
	# Check if the buttons are valid
	if int_button == null or per_button == null:
		print("Error: One or more buttons not found.")
		return
	
	print("Buttons found successfully!")  # Debugging line
	
	# Connect button signals to their corresponding functions
	int_button.pressed.connect(_on_int_button_pressed)  # Corrected connection method
	per_button.pressed.connect(_on_per_button_pressed)  # Corrected connection method

	# Read the dialogue from the text file
	var file = FileAccess.open("res://dialogues.txt", FileAccess.READ)  # Open the file for reading
	if file:
		var text = file.get_as_text()
		file.close()
		
		parse_dialogue(text)
	
	# Display the first line of dialogue (or empty if none)
	update_dialogue()

# Parse the dialogue based on type (PER and INT)
func parse_dialogue(dialogue_content):  # Changed the parameter name to avoid shadowing
	var lines = dialogue_content.split("\n")
	var current_type = ""
	
	for line in lines:
		if line == "PER":
			current_type = "PER"
		elif line == "INT":
			current_type = "INT"
		elif line.strip_edges() != "":
			if current_type == "PER":
				per_dialogue.append(line)
			elif current_type == "INT":
				int_dialogue.append(line)

# Update the dialogue text on the screen
func update_dialogue():
	if current_line < current_dialogue.size():
		dialogue_text.text = current_dialogue[current_line]
	else:
		dialogue_text.text = "End of dialogue."

# Show INT dialogue when INT button is pressed
func _on_int_button_pressed():
	print("INT Button Pressed!")  # Debugging line
	current_line = 0  # Reset to the first line of INT dialogue
	current_dialogue = int_dialogue  # Set the current dialogue to INT
	update_dialogue()

# Show PER dialogue when PER button is pressed
func _on_per_button_pressed():
	print("PER Button Pressed!")  # Debugging line
	current_line = 0  # Reset to the first line of PER dialogue
	current_dialogue = per_dialogue  # Set the current dialogue to PER
	update_dialogue()
