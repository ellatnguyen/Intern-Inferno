extends Panel

@onready var item_visual: Sprite2D=$CenterContainer/Panel/item_display
@onready var amount_text: Label =$CenterContainer/Panel/Label


func update(slot:InvSlot):
	if !slot.item:
		item_visual.visible =false
		amount_text.visible=false
	else:
		item_visual.visible=true
		item_visual.texture=slot.item.texture
		item_visual.scale = Vector2(.9, .9)  # tweak this if needed
		item_visual.centered = true
		item_visual.position = Vector2.ZERO
		if slot.amount > 1:
			amount_text.visible=true
		amount_text.text=str(slot.amount)
		
