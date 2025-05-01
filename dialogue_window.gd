extends Control

@onready var dialogue_text = $DialogueBoxesWithDarkenedBackground/DialogueText
@onready var int_button = $INT_Button
@onready var per_button = $PER_Button
@onready var leave_button = $LEAVE_Button
@onready var health_bar = $"EnemyPortrait/ComplianceBar"
@onready var enemy_portrait = $EnemyPortrait
@onready var productivity_bar = get_node("/root/Game/TimerUI/Container/ProductivityBar")  # Adjust path as needed
@onready var per_label = get_node("/root/Game/InventoryUI/Inv_UI/ClosedClipboard/PER_LVL_CLOSED")
@onready var int_label = get_node("/root/Game/InventoryUI/Inv_UI/ClosedClipboard/PER_LVL_CLOSED")

var battle_ended = false

var current_int_line = 0
var current_per_line = 0

var per_dialogue = []
var int_dialogue = []
var current_dialogue = []

const MAX_HEALTH = 11
var enemy_health = MAX_HEALTH

# Variables to store for cooldown bar / exp gain
var int_count = 0
var per_count = 0

# Hold a reference to the enemy
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
	# Reset all previous battle state
	reset_battle()  # Ensure everything is cleared before starting a new battle

	print("Battle started with:", enemy.name)
	GameManager.in_battle = true

	# Disable player controls
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.controls_enabled = false

	current_enemy = enemy
	enemy_health = enemy.stats.get("MAX_HEALTH", MAX_HEALTH)
	update_health_bar()  # Reflect new enemy health
	
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
	int_count += 1
	current_dialogue = int_dialogue
	if current_int_line < int_dialogue.size():
		update_dialogue()
		var base_dmg = current_enemy.stats.get("INT_DMG", 1)
		var bonus_dmg = get_bonus_damage("INT")
		decrease_enemy_health(base_dmg + bonus_dmg)
		current_int_line += 1
	else:
		dialogue_text.text = "End of INT dialogue."

func _on_per_button_pressed():
	print("PER Button Pressed!")
	per_count += 1
	current_dialogue = per_dialogue
	if current_per_line < per_dialogue.size():
		update_dialogue()
		var base_dmg = current_enemy.stats.get("PER_DMG", 2)
		var bonus_dmg = get_bonus_damage("PER")
		decrease_enemy_health(base_dmg + bonus_dmg)
		current_per_line += 1
	else:
		dialogue_text.text = "End of PER dialogue."


func decrease_enemy_health(amount := 1):
	if enemy_health > 0:
		enemy_health -= amount
		enemy_health = max(enemy_health, 0)
		update_health_bar()

		if enemy_health == 0 and not battle_ended:
			battle_ended = true
			print("Enemy defeated!")

			if productivity_bar:
				print("Incrementing Productivity Bar!")
				productivity_bar.increase_productivity_by_percent(0.2)
			
			if is_inside_tree():
				var player = get_tree().get_first_node_in_group("player")
				if player:
					var exp_gain = 1 + (randi() % 3)  # 1 to 3 EXP

					if int_count > per_count:
						player.gain_int_exp(exp_gain)
					elif per_count > int_count:
						player.gain_per_exp(exp_gain)
					else:
						player.gain_int_exp(3)
						player.gain_per_exp(3)
				else:
					print("Player not found in scene tree.")
				print(player.player_stats)
			
			end_battle()  # Ensure battle always ends cleanly


func update_health_bar():
	if health_bar:
		health_bar.frame = enemy_health
		print("Enemy Health:", enemy_health)
	else:
		print("Error: Health bar not found.")

func reset_battle():
	self.visible = false
	for child in get_children():
		child.visible = false

	# Clear battle state variables
	battle_ended = false
	enemy_health = MAX_HEALTH
	current_int_line = 0
	current_per_line = 0
	current_enemy = null

	# Clear dialogue data
	per_dialogue.clear()
	int_dialogue.clear()

	# Reset health bar visuals
	update_health_bar()

	# Clear enemy portrait
	enemy_portrait.texture = null

	# Re-enable player controls
	GameManager.in_battle = false
	if productivity_bar.is_full == false:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.controls_enabled = true

func _on_leave_button_pressed():
	print("LEAVE Button Pressed!")
	reset_battle()

func end_battle():
	print("Battle Over!")
	#i forgot to get rid of the UI before despawning ;-;
	self.visible=false
	for child in get_children():
		child.visible=false

	var defeated_enemy = current_enemy
	current_enemy=null
	
	GameManager.in_battle=false
	
	if is_inside_tree():
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.controls_enabled= true
		else:
			print("dialogue windo is no longer inside the scene tree")

	if defeated_enemy and is_instance_valid(defeated_enemy) and defeated_enemy.has_method("despawn"):
		defeated_enemy.despawn()

func get_bonus_damage(stat_type: String) -> int:
	if not is_inside_tree():
		return 0

	var player = get_tree().get_first_node_in_group("player")
	if player:
		if stat_type == "INT":
			return player.player_stats.get("INT_LVL", 0)
		elif stat_type == "PER":
			return player.player_stats.get("PER_LVL", 0)
	return 0
