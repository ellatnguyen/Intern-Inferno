extends Control

var inv: Inv  # No preload!
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var closed_clipboard: Node=$ClosedClipboard
@onready var inventory_panel: Node=$NinePatchRect
@onready var label_per_level = $NinePatchRect/PER_LVL
@onready var label_int_level = $NinePatchRect/INT_LVL
@onready var label_per_level_closed = $ClosedClipboard/PER_LVL_CLOSED
@onready var label_int_level_closed = $ClosedClipboard/INT_LVL_CLOSED

@onready var item_description_label: Label = $NinePatchRect/ItemDescriptionLabel

#challenge: let's make this as inefficient as possible 
#i'm sorry i literally do not know any other way and my brain isnt funcitioning
@onready var intimidate1: Node=$NinePatchRect/INT1
@onready var intimidate2: Node=$NinePatchRect/INT2
@onready var intimidate3: Node=$NinePatchRect/INT3
@onready var persuasion1: Node=$NinePatchRect/PER1
@onready var persuasion2: Node=$NinePatchRect/PER2
@onready var persuasion3: Node=$NinePatchRect/PER3
@onready var c_intimidate1: Node=$ClosedClipboard/c_int1
@onready var c_intimidate2: Node=$ClosedClipboard/c_int2
@onready var c_intimidate3: Node=$ClosedClipboard/c_int3
@onready var c_persuasion1: Node=$ClosedClipboard/c_per1
@onready var c_persuasion2: Node=$ClosedClipboard/c_per2
@onready var c_persuasion3: Node=$ClosedClipboard/c_per3


var selected_index := 0  # Index of currently hovered slot
var is_open = false

func _ready():
	add_to_group("inventory_ui")
	intimidate1.visible=true
	persuasion1.visible=true
	intimidate2.visible=false
	intimidate3.visible=false
	persuasion2.visible=false
	persuasion3.visible=false
	
	c_intimidate1.visible=true
	c_intimidate2.visible=false
	c_intimidate3.visible=false
	c_persuasion1.visible=true
	c_persuasion2.visible=false
	c_persuasion3.visible=false
	
	inv.update.connect(update_slots)
	update_slots()
	close() 

func update_slots():
	print("updating inventoring UI...")
	for i in range(min(inv.slots.size(), slots.size())):
		print("Slot ", i, " - Item: ", inv.slots[i].item, " Amount: ", inv.slots[i].amount)
		slots[i].update(inv.slots[i])

func set_inventory(inventory: Inv):
	inv = inventory
	inv.update.connect(update_slots)
	update_slots()

func _on_slot_hovered(slot: InvSlot):
	if slot.item:
		item_description_label.text = slot.item.name
	else:
		item_description_label.text = "boo"


func _process(_delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()
	if is_open:
		if Input.is_action_just_pressed("move_left"):
			selected_index = max(0, selected_index - 1)
			update_slot_selection()
		elif Input.is_action_just_pressed("move_right"):
			selected_index = min(slots.size() - 1, selected_index + 1)
			update_slot_selection()
		elif Input.is_action_just_pressed("interact"):  # "E" key
			consume_selected_item()

func open():
	inventory_panel.visible = true
	closed_clipboard.visible = false
	is_open = true
	selected_index=0
	update_level_display()
	update_slot_selection()
	WwiseManager.set_menu_state(true)


func close():
	inventory_panel.visible=false
	closed_clipboard.visible=true
	is_open = false
	WwiseManager.set_menu_state(false)


func update_slot_selection():
	for i in range(slots.size()):
		slots[i].set_hovered(i == selected_index)
	
	var slot = inv.slots[selected_index]
	if slot.item:
		if slot.item.name =="lucky harms":
			item_description_label.text = "Lucky Harms: Mischievous cereal with magical luck. Increases EXP gain after your next successful battle."
		elif slot.item.name =="scrappy":
			item_description_label.text = "Scrappy: A jagged charm buzzing with energy. Temporarily boosts your dialogue damage by 50%."
		elif slot.item.name =="fahrenheit":
			item_description_label.text = "Fahrenheit: A flickering flame in a bottle. Doubles your movement speed for a short time"
		elif slot.item.name =="life sparer":
			item_description_label.text = "Life Sparer: A soft glowing orb of purpose. Instantly increases your productivity by 1%."
	else:
		item_description_label.text = ""

func consume_selected_item():
	var slot = inv.slots[selected_index]
	if slot.item:
		var item_name =slot.item.name
		print("Consumed item: ", slot.item.name)
		
		if item_name=="scrappy":
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.has_damage_boost = true
				print ("!? Damage boost activated")
				WwiseManager.trigger_damage_buff(true)
		elif item_name=="fahrenheit":
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.speed_multiplier = 1.8
				player.fahrenheit_timer.start()
				print ("!!!! Fahrenheit consumed! Speed doubled")
				WwiseManager.trigger_energy_drink(true)
		elif item_name =="lucky harms":
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.has_exp_boost=true
				print("YAYA Lucky Harms consumed. EXP Gain increased")
				WwiseManager.trigger_xp_boost(true)
		elif item_name=="life sparer":
			var productivity_bar = get_node_or_null("/root/Game/TimerUI/Container/ProductivityBar")
			if productivity_bar:
				productivity_bar.increase_productivity_by_percent(0.01)
				print("Life Sparer consumed! Productivity +1%")
				WwiseManager.trigger_lifesparer()
			else:
				print("Productivity bar not found.")
		#get rid of item/reduce
		slot.amount -= 1
		if slot.amount <= 0:
			slot.item = null
		inv.update.emit()
		update_slot_selection()



func update_level_display():
	var player = get_tree().get_first_node_in_group("player")
	var int_lvl = 1
	var per_lvl = 1

	if player:
		int_lvl = player.player_stats.get("INT_LVL", 1)
		per_lvl = player.player_stats.get("PER_LVL", 1)

	# Open clipboard - Intimidate
	intimidate1.visible = int_lvl == 1
	intimidate2.visible = int_lvl == 2
	intimidate3.visible = int_lvl == 3

	# Open clipboard - Persuade
	persuasion1.visible = per_lvl == 1
	persuasion2.visible = per_lvl == 2
	persuasion3.visible = per_lvl == 3

	# Closed clipboard - Intimidate
	c_intimidate1.visible = int_lvl == 1
	c_intimidate2.visible = int_lvl == 2
	c_intimidate3.visible = int_lvl == 3

	# Closed clipboard - Persuade
	c_persuasion1.visible = per_lvl == 1
	c_persuasion2.visible = per_lvl == 2
	c_persuasion3.visible = per_lvl == 3
	
func update_inventory_ui():
	var inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if inventory_ui:
		print("Updating UI:", inventory_ui)
		inventory_ui.update_level_display()
	else:
		print("!! Inventory UI not found in tree")
