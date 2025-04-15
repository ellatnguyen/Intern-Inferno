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
