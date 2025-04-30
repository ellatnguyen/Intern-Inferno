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



var is_open = false

func _ready():
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
	intimidate1.visible=true
	persuasion1.visible=true
	if player:
		var per_lvl = player.player_stats.get("PER_LVL", 0)
		var int_lvl = player.player_stats.get("INT_LVL", 0)
		
		if int_lvl == 2:
			intimidate1.visible=false
			intimidate2.visible=true
			intimidate3.visible=false
		if per_lvl==2:
			persuasion1.visible=false
			persuasion2.visible=true
			persuasion3.visible=false
			
			
		
		label_per_level.text = "PER Level: " + str(per_lvl)
		label_int_level.text = "INT Level: " + str(int_lvl)
		label_per_level_closed.text = "PER Level: " + str(per_lvl)
		label_int_level_closed.text = "INT Level: " + str(int_lvl)
	else:
		label_per_level.text = "PER Level: ?"
		label_int_level.text = "INT Level: ?"
		label_per_level_closed.text = "PER Level: ?"
		label_int_level_closed.text = "INT Level: ?"
