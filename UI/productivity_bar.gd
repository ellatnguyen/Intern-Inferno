extends AnimatedSprite2D

@onready var timer: Timer = $"ProductivityTimer" 

const TOTAL_FRAMES: int = 29
var current_frame: int = 14  # Start around 50%
var game_over: bool = false
var is_full: bool = false

var max_value := 100.0
var value := 0.0

func _ready():
	play()
	stop()
	
	value = (1.0 - float(current_frame) / TOTAL_FRAMES) * max_value

	update_productivity_animation()

	#timer.wait_time = 0.2
	timer.wait_time = 2
	timer.start()
	timer.timeout.connect(_on_productivity_timer_timeout)

func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_accept"):  # Default maps to Spacebar
		#decrement_frame()

func increment_frame():
	current_frame += 1
	current_frame = clamp(current_frame, 0, TOTAL_FRAMES)
	update_productivity_animation()

	if current_frame >= TOTAL_FRAMES:
		productivity_end()  # now correctly triggers loss
		
func increase_productivity_by_percent(percent: float):
	var increase_amount = percent * max_value
	value = min(value + increase_amount, max_value)
	print("Productivity now at", value, "/", max_value)

	# Translate value to frame (based on 0 to TOTAL_FRAMES range)
	current_frame = clamp(TOTAL_FRAMES - round((value / max_value) * TOTAL_FRAMES), 0, TOTAL_FRAMES)
	update_productivity_animation()

	if value >= max_value:
		is_full = true
		print("You win! Transitioning to WinScreen...")

		# Just in case frame is off-sync
		current_frame = TOTAL_FRAMES
		update_productivity_animation()

		# Optional: Stop the timer
		timer.stop()

		var dialogue_battle = get_node_or_null("/root/Game/DialogueBattleUI/DialogueWindow")
		if dialogue_battle:
			dialogue_battle.reset_battle()
		
		get_tree().change_scene_to_file("res://UI/WinScreen.tscn")

func decrement_frame():
	current_frame -= 1
	current_frame = clamp(current_frame, 0, TOTAL_FRAMES)
	update_productivity_animation()

	if current_frame <= 0:
		productivity_win()  # You won because productivity bar is full

func update_productivity_animation():
	if animation != "productivityrun":
		animation = "productivityrun"
	frame = current_frame
	print("Frame:", current_frame)

func productivity_end():
	if game_over: return
	game_over = true
	print("Productivity Drained!")
	timer.stop()
	get_tree().change_scene_to_file("res://UI/LoseScreen.tscn")  # Update path

func productivity_win():
	if game_over: return
	game_over = true
	print("Productivity Maxed! You Win!")
	timer.stop()
	get_tree().change_scene_to_file("res://UI/WinScreen.tscn")  # Update path

func _on_productivity_timer_timeout():
	increment_frame()
