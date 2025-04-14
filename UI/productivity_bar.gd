extends AnimatedSprite2D

@onready var timer: Timer = $"ProductivityTimer" 

const TOTAL_FRAMES: int = 29  # Frames range from 0 to 38
var current_frame: int = 0  # Track the current frame

func _ready():
	play()  # Initialize animation
	stop()  # Prevent auto-playing

	update_productivity_animation()

	timer.wait_time = 0.2  # Debug time interval (adjust as needed)
	timer.start()
	timer.timeout.connect(_on_productivity_timer_timeout)

func increment_frame():
	current_frame += 1
	if current_frame >= TOTAL_FRAMES:
		productivity_end()

func update_productivity_animation():
	if animation != "productivityrun":
		animation = "productivityrun"

	frame = current_frame  

	print("Frame:", current_frame)  # Debug output

func productivity_end():
	print("Productivity Drained!")  
	timer.stop()

func _on_productivity_timer_timeout():
	increment_frame()
	update_productivity_animation()

#@export var max_health: float = 100.0 # Setting Health
#@export var drain_rate: float = 10.0  # Health lost per second
#@export var heal_amount: float = 20.0  # Health restored when input
#
#var current_health: float
#
#func _ready():
	#current_health = max_health
	#value = current_health
	#set_process(true)
#
#func _process(delta):
	#current_health = max(0, current_health - drain_rate * delta)
	#value = current_health
	#
	## REPLACE WITH BATTLE SIGNAL ?
	#if Input.is_action_just_pressed("ui_accept"):
		#heal()
#
#func heal():
	#current_health = min(max_health, current_health + heal_amount)
	#value = current_health
