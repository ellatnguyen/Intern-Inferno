extends Node

# Map character names to their dialogue file paths
var dialogue_files = {
	"Fire_Imp_Singular": "res://Dialogues/Fire_Imp_Singular.txt",
	"Fire_Imp_Multiple": "res://Dialogues/Fire_Imp_Multiple.txt",
	"Grandma": "res://Dialogues/Grandma_Dialogue.txt",
	"Slime": "res://Dialogues/Slime_Dialogue.txt"
}

# Stores dialogues for all characters in memory
var dialogues = {}

# Tracks which character is currently active
var current_character = ""

# UI Elements
onready var dialogue_box = $DialogueBox
onready var intimidate_button = $IntimidateButton
onready var persuade_button = $PersuadeButton

func _ready():
	# Load dialogues at startup
	for character in dialogue_files.keys():
		load_dialogue(character)

	# Connect buttons
	intimidate_button.connect("pressed", self, "_on_intimidate_button_pressed")
	persuade_button.connect("pressed", self, "_on_persuade_button_pressed")

# Load dialogues for a specific character from file
func load_dialogue(character):
	var path = dialogue_files[character]
	var file = File.new()

	if file.file_exists(path):
		file.open(path, File.READ)
		var current_section = ""
		dialogues[character] = {}

		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "":
				continue

			# Section header detection (like "Green")
			if line.ends_with("Green") or line == "Green":
				current_section = line
				dialogues[character][current_section] = []
			elif current_section != "":
				dialogues[character][current_section].append(line)

		file.close()

# Start dialogue interaction for a character
func start_dialogue(character):
	if dialogues.has(character):
		current_character = character
		dialogue_box.text = "Press Intimidate or Persuade."
	else:
		dialogue_box.text = "No dialogue found for this character."

# Handle Intimidate button
func _on_intimidate_button_pressed():
	if current_character != "":
		show_dialogue("Green")

# Handle Persuade button
func _on_persuade_button_pressed():
	if current_character != "":
		show_dialogue("Green")

# Show a dialogue line from a category for the current character
func show_dialogue(category):
	if dialogues.has(current_character):
		var character_dialogue = dialogues[current_character]
		if character_dialogue.has(category):
			var lines = character_dialogue[category]
			if lines.size() > 0:
				dialogue_box.text = lines[randi() % lines.size()]
			else:
				dialogue_box.text = "No lines in this category."
		else:
			dialogue_box.text = "No such category."
	else:
		dialogue_box.text = "No dialogue for this character."
