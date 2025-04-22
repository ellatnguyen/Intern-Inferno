extends AnimatedSprite2D

@onready var timer: Timer = $"ProductivityTimer" 

const TOTAL_FRAMES: int = 29
var current_frame: int = 14  # Start around 50%

func _ready():
	play()
	stop()

	update_productivity_animation()

	#timer.wait_time = 0.2
	timer.wait_time = 0.2
	timer.start()
	timer.timeout.connect(_on_productivity_timer_timeout)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Default maps to Spacebar
		decrement_frame()

func increment_frame():
	current_frame += 1
	if current_frame >= TOTAL_FRAMES:
		productivity_end()
	else:
		update_productivity_animation()

func decrement_frame():
	current_frame -= 1
	if current_frame <= 0:
		current_frame = 0
		productivity_win()
	else:
		update_productivity_animation()

func update_productivity_animation():
	if animation != "productivityrun":
		animation = "productivityrun"
	frame = current_frame
	print("Frame:", current_frame)

func productivity_end():
	print("Productivity Drained!")
	timer.stop()
	get_tree().change_scene_to_file("res://UI/LoseScreen.tscn")  # Update path

func productivity_win():
	print("Productivity Maxed! You Win!")
	timer.stop()
	get_tree().change_scene_to_file("res://UI/WinScreen.tscn")  # Update path

func _on_productivity_timer_timeout():
	increment_frame()
