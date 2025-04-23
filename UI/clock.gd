extends AnimatedSprite2D

@onready var timer: Timer = $"ClockTimer"  # Adjust path as needed

const TOTAL_FRAMES: int = 39  # Frames range from 0 to 38
var current_frame: int = 0  # Track the current frame

func _ready():
	play()  # Initialize animation
	stop()  # Prevent auto-playing

	update_clock_animation()

	timer.wait_time = 10.0  # Debug time interval (adjust as needed)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	increment_frame()
	update_clock_animation()

func increment_frame():
	current_frame += 1
	if current_frame >= TOTAL_FRAMES:
		end_work_day()

func update_clock_animation():
	if animation != "clockrun":
		animation = "clockrun"

	frame = current_frame  

	print("Frame:", current_frame)  # Debug output

func end_work_day():
	print("Workday Over!")  
	timer.stop()
	get_tree().change_scene_to_file("res://UI/LoseScreen.tscn")
