extends Control

@onready var inv: Inv=preload("res://inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


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


func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible=true
	is_open=true
	
func close():
	visible=false
	is_open = false
