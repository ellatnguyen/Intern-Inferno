extends ProgressBar

@export var max_health: float = 100.0
@export var base_drain_rate: float = 10.0  # Maximum drain rate
@export var min_drain_rate: float = 5.0  # Minimum drain rate
@export var heal_amount: float = 20.0  # Health restored when pressing space

var current_health: float
@onready var boss_cutscene: Control = $"../BossOfficeCutscene"

func _ready():
	current_health = max_health
	value = current_health
	set_process(true)
	boss_cutscene.visible = false  # Ensure cutscene is hidden at the start

func _process(delta):
	if current_health > 0:
		var dynamic_drain_rate = calculate_drain_rate()
		current_health = max(0, current_health - dynamic_drain_rate * delta)
		value = current_health

	if current_health == 0:
		trigger_cutscene()

	if Input.is_action_just_pressed("ui_accept"):  # Spacebar heals
		heal()

func calculate_drain_rate() -> float:
	var health_ratio = current_health / max_health
	return min_drain_rate + (base_drain_rate - min_drain_rate) * health_ratio

func heal():
	current_health = min(max_health, current_health + heal_amount)
	value = current_health

func trigger_cutscene():
	boss_cutscene.visible = true  # Show the cutscene
