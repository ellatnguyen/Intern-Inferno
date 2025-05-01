extends Control

@onready var bar_sprite: AnimatedSprite2D = $CooldownBarSprite
@onready var cooldown_timer: Timer = $CooldownBarSprite/CooldownTimer
@onready var player = get_node("/root/Game/Player")

# Constants
const TOTAL_FRAMES = 12
const COOLDOWN_DURATION = 5.0  # seconds
const OFFSET = Vector2(1, -3)

signal cooldown_finished

func _ready():
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(delta):
	if self.visible and player:
		global_position = player.global_position + OFFSET

func start_cooldown():
	self.visible = true
	bar_sprite.frame = 0
	bar_sprite.play("default")

	cooldown_timer.wait_time = COOLDOWN_DURATION / TOTAL_FRAMES
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	if bar_sprite.frame < TOTAL_FRAMES - 1:
		bar_sprite.frame += 1
	else:
		cooldown_timer.stop()
		self.visible = false
		emit_signal("cooldown_finished")
