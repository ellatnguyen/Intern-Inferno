extends ProgressBar

@export var max_health: float = 100.0 # Setting Health
@export var drain_rate: float = 10.0  # Health lost per second
@export var heal_amount: float = 20.0  # Health restored when input

var current_health: float

func _ready():
	current_health = max_health
	value = current_health
	set_process(true)

func _process(delta):
	current_health = max(0, current_health - drain_rate * delta)
	value = current_health
	
	# REPLACE WITH BATTLE SIGNAL ?
	if Input.is_action_just_pressed("ui_accept"):
		heal()

func heal():
	current_health = min(max_health, current_health + heal_amount)
	value = current_health
