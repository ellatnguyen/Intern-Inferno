extends Control

@onready var inv: Inv=preload("res://inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var closed_clipboard: Node=$ClosedClipboard
@onready var inventory_panel: Node=$NinePatchRect
@onready var label_per_level = $NinePatchRect/PER_LVL
@onready var label_int_level = $NinePatchRect/INT_LVL
@onready var label_per_level_closed = $ClosedClipboard/PER_LVL_CLOSED
@onready var label_int_level_closed = $ClosedClipboard/INT_LVL_CLOSED
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



var is_open = false

func _ready():
	print("🧩 Inv_UI _ready called!")
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


func _process(_delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	inventory_panel.visible = true
	closed_clipboard.visible = false
	is_open = true
	update_level_display()
	
func close():
	inventory_panel.visible=false
	closed_clipboard.visible=true
	is_open = false

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
		print("⚠️ Inventory UI not found in tree")
