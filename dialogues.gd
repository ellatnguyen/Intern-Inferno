extends Node

var dialogue_file_path = "res://dialogues/Fire_Imp_Multiple.txt"
var fire_imp_dialogue = {}  # Dictionary to hold all categories and their lines

onready var dialogue_box = $DialogueBox
onready var intimidate_button = $IntimidateButton
onready var persuade_button = $PersuadeButton

func _ready():
	load_fire_imp_dialogue()
	intimidate_button.connect("pressed", self, "_on_intimidate_button_pressed")
	persuade_button.connect("pressed", self, "_on_persuade_button_pressed")

func load_fire_imp_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file_path):
		file.open(dialogue_file_path, File.READ)
		var current_section = ""

		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "":
				continue  # skip empty lines

			# If line matches one of your category headers
			if line.ends_with("Green") or line == "Green":
