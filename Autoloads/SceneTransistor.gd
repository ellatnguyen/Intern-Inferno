extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
var tween: Tween
var pending_fade_in := false

func _ready():
	color_rect.modulate.a = 1.0  # Start fully black
	color_rect.visible = true
	pending_fade_in = true

func _process(delta):
	if pending_fade_in and is_instance_valid(get_tree().current_scene):
		pending_fade_in = false
		await get_tree().process_frame  # Wait for scene to finish loading
		await fade_in()

func fade_in():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween.finished

func change_scene_with_fade(path: String) -> void:
	print("Fading out to change scene to: ", path)
	if tween: tween.kill()

	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished

	pending_fade_in = true
	get_tree().change_scene_to_file(path)

#extends CanvasLayer
#
#@onready var color_rect: ColorRect = $ColorRect
#var tween: Tween
#var new_scene_path: String
#
#func _ready():
	#color_rect.modulate.a = 0  # Start transparent
	#color_rect.visible = true
#
#func change_scene_with_fade(path: String) -> void:
	#if tween:
		#tween.kill()
#
	#tween = create_tween()
	#tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	#await tween.finished
#
	#get_tree().change_scene_to_file(path)
	#await get_tree().process_frame  # Wait a frame to let scene load
#
	#color_rect.modulate.a = 1.0  # Ensure fully black
	#tween = create_tween()
	#tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	#await tween.finished
#
#func fade_in_on_start():
	#color_rect.modulate.a = 1.0
	#tween = create_tween()
	#tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	#await tween.finished
