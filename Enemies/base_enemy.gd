class_name BaseEnemy
extends CharacterBody2D

signal player_near(state)

const POOF_SCENE = preload("res://Enemies/defeat/PoofEffect.tscn")

var player_is_near=false

var stats = {
	"PER_DMG": 1,
	"INT_DMG": 1,
}

var dialogue_file_path: String = ""
var dialogue_sprite: Texture = null

@onready var interaction_area = $InteractionArea  # Adjust if your structure differs
@onready var enemy_animation = $AnimatedSprite2D

func _ready():
	enemy_animation.play()
	
	if interaction_area:
		interaction_area.connect("body_entered", Callable(self, "_on_interaction_area_body_entered"))
		interaction_area.connect("body_exited", Callable(self, "_on_interaction_area_body_exited"))

func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		print("Player entered interaction area")
		player_is_near=true
		emit_signal("player_near", true, self)

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		print("Player exited interaction area")
		player_is_near=false
		emit_signal("player_near", false)

func is_player_near()->bool:
	return player_is_near
	
func despawn():
	print("Despawning enemy")
	
	#disable the interactiosn first
	interaction_area.set_deferred("monitoring", false)
	$CollisionShape2D.set_deferred("disabled", true)
	
	var poof = POOF_SCENE.instantiate()
	get_tree().current_scene.add_child(poof)
	poof.global_position=global_position
	
	await get_tree().create_timer(0.3).timeout
	queue_free()
