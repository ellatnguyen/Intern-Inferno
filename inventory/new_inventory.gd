extends Resource

class_name InvFactory

static func create_inventory(slot_count: int = 10) -> Inv:
	var inv := Inv.new()
	inv.slots = []
	for i in range(slot_count):
		var slot := InvSlot.new()
		slot.item = null
		slot.amount = 0
		inv.slots.append(slot)
	return inv
