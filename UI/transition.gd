extends Control

@onready var color_rect: ColorRect = $ColorRect
var tween: Tween

func _ready():
	color_rect.color = Color.BLACK
	color_rect.modulate.a = 0  # Ensure it starts transparent
	set_process_input(true)

func fade_to_scene(target_scene: String):
	if tween: tween.kill()  # Stop any existing animations
	tween = create_tween()

	# Fade to black
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished

	get_tree().change_scene_to_file(target_scene)  # Change scene

	# Fade back in
	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
