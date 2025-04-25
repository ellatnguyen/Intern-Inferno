extends Resource
 
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D


func _ready():
	self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
