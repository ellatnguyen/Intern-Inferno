extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item:InvItem):
	print("attempting to insert")
	var itemslots=slots.filter(func(slot): return slot.item==item)
	if !itemslots.is_empty():
		print("item exists in inventory, increasing amt")
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item==null)
		if !emptyslots.is_empty():
			print("adding item to empty slot")
			emptyslots[0].item=item
			emptyslots[0].amount=1
		else:
			print("no empty slots available")
	update.emit()
	
