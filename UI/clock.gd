extends Node

@onready var time_label: Label = $ClockLabel
@onready var timer: Timer = $ClockTimer

var current_hour: int = 8
var current_minute: int = 0
var is_am: bool = true  # Time is in 12-hour format

func _ready():
	update_time_label()
	#timer.wait_time = 30.0  # 30 seconds real-time = 30 minutes game time
	timer.wait_time = 5.0 # 5 seconds for debugging bc im lazy.
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	increment_time()
	update_time_label()

func increment_time():
	current_minute += 30
	if current_minute >= 60:
		current_minute = 0
		current_hour += 1
		
		if current_hour == 12:
			is_am = !is_am  # Switch AM/PM
		elif current_hour > 12:
			current_hour -= 12

	if current_hour == 5 and not is_am:  # 5:00 PM ends the workday
		end_work_day()

func update_time_label():
	var period = "AM" if is_am else "PM"
	time_label.text = "Day # %d:%02d %s" % [current_hour, current_minute, period]

func end_work_day():
	print("Workday Over!")  # TRIGGER EOD SCREEN?
	timer.stop()
