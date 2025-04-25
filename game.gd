extends Node

var dialogue_file_path = "res://dialogues/Fire_Imp_Multiple.txt"

var intimidation_dialogues = []
var persuasion_dialogues = []
var current_dialogue_index = 0
var current_mode = "INT"  # can be "INT" or "PER"

onready var dialogue_box = $DialogueBox
onready var intimidate_button = $IntimidateButton
onready var persuade_button = $PersuadeButton

func _ready():
	parse_dialogue()
	intimidate_button.connect("pressed", self, "_on_intimidate_button_pressed")
	persuade_button.connect("pressed", self, "_on_persuade_button_pressed")

func parse_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file_path):
		file.open(dialogue_file_path, File.READ)
		var lines = []
		while not file.eof_reached():
			lines.append(file.get_line())
		file.close()

		var current_list = []
		for line in lines:
			if line == "INT":
				current_mode = "INT"
				continue
			elif line == "PER":
				current_mode = "PER"
				continue
			elif line.strip_edges() == "":
				continue
			else:
				if current_mode == "INT":
					intimidation_dialogues.append(line)
				elif current_mode == "PER":
					persuasion_dialogues.append(line)
	else:
		print("Dialogue file not found at path: ", dialogue_file_path)

func _on_intimidate_button_pressed():
	if intimidation_dialogues.size() == 0:
		dialogue_box.text = "No intimidation dialogues found."
		return

	dialogue_box.text = intimidation_dialogues[current_dialogue_index]
	current_dialogue_index += 1
	if current_dialogue_index >= intimidation_dialogues.size():
		current_dialogue_index = 0  # reset or disable button here if you want

func _on_persuade_button_pressed():
	if persuasion_dialogues.size() == 0:
		dialogue_box.text = "No persuasion dialogues found."
		return

	dialogue_box.text = persuasion_dialogues[current_dialogue_index]
	current_dialogue_index += 1
	if current_dialogue_index >= persuasion_dialogues.size():
		current_dialogue_index = 0  # reset or disable button here if you want
