extends Control

@onready var dialogue_text = $DialogueBoxesWithDarkenedBackground/DialogueText
@onready var int_button = $INT_Button
@onready var per_button = $PER_Button
@onready var leave_button = $LEAVE_Button
@onready var health_bar = $"PrototypeEnemy/ComplianceBar"
@onready var enemy_portrait = $EnemyPortrait

var current_int_line = 0
var current_per_line = 0

var per_dialogue = []
var int_dialogue = []
var current_dialogue = []

const MAX_HEALTH = 11
var enemy_health = MAX_HEALTH

# New: hold a reference to the enemy
var current_enemy: Node = null

func _ready():
	if int_button == null or per_button == null:
		print("Error: One or more buttons not found.")
		return
	
	print("Buttons found successfully!")
	# UI hidden by default; gets shown in start_battle_with
	self.visible = false

func _unhandled_input(event):
	if not self.visible:
		return  # Only allow inputs during battle

	if event.is_action_pressed("battle_per"):
		_on_per_button_pressed()
	elif event.is_action_pressed("battle_int"):
		_on_int_button_pressed()
	elif event.is_action_pressed("battle_leave"):
		_on_leave_button_pressed()
		
func start_battle_with(enemy: Node):
	print("Battle started with:", enemy.name)

	current_enemy = enemy
	current_int_line = 0
	current_per_line = 0

	# Read enemy stats
	enemy_health = enemy.stats.get("MAX_HEALTH", MAX_HEALTH)
	per_dialogue.clear()
	int_dialogue.clear()
	
	# Load dialogue from enemy
	if enemy.dialogue_file_path != "":
		var file = FileAccess.open(enemy.dialogue_file_path, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			file.close()
			parse_dialogue(text)
		else:
			print("Failed to open dialogue file:", enemy.dialogue_file_path)
	else:
		print("Enemy has no dialogue_file_path.")
	

	# Set starting dialogue type (optional: choose based on enemy preference?)
	current_dialogue = int_dialogue
	
	# Set portrait if available
	if enemy.dialogue_sprite:
		enemy_portrait.texture = enemy.dialogue_sprite
	else:
		enemy_portrait.texture = null  # or a default "mystery" portrait
	# Make UI visible
	self.visible = true
	for child in get_children():
		child.visible = true

	# Enable buttons
	int_button.visible = true
	per_button.visible = true
	leave_button.visible = true

	int_button.disabled = false
	per_button.disabled = false
	leave_button.disabled = false

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
				per_dialogue.append(line.strip_edges())
			elif current_type == "INT":
				int_dialogue.append(line.strip_edges())

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
	if current_int_line < int_dialogue.size():
		update_dialogue()
		var dmg = current_enemy.stats.get("INT_DMG", 1)
		decrease_enemy_health(dmg)
		current_int_line += 1
	else:
		dialogue_text.text = "End of INT dialogue."

func _on_per_button_pressed():
	print("PER Button Pressed!")
	current_dialogue = per_dialogue
	if current_per_line < per_dialogue.size():
		update_dialogue()
		var dmg = current_enemy.stats.get("PER_DMG", 2)
		decrease_enemy_health(dmg)
		current_per_line += 1
	else:
		dialogue_text.text = "End of PER dialogue."

func decrease_enemy_health(amount := 1):
	if enemy_health > 0:
		enemy_health -= amount
		enemy_health = max(enemy_health, 0)
		update_health_bar()

		if enemy_health == 0:
			end_battle()

func update_health_bar():
	if health_bar:
		health_bar.frame = enemy_health
		print("Enemy Health:", enemy_health)
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
