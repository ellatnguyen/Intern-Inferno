extends Control

@onready var slideshow = $Slideshow
@onready var dialogue_label = $DialogueLabel
@onready var name_label = $NameLabel

var current_frame := 0

var name_lines := [
	"", # 1: Black Screen with Music (Frame 0)
	"", # 2: Open w/ MC + Skelly (Frame 1)
	"Satan", # 3.1: Satan Talks (Frame 2)
	"Skelly", # 3.2: Skelly Responds (Frame 3)
	"Skelly", # 3.3: Skelly Continues (Frame 4)
	"Skelly", # 3.4: Skelly Tutorial (Frame 5)
	"", # 4: Pause (Frame 6)
	"", # 5: Satan Grabs Through Phone (Frame 7)
	"", # 6: Skelly is Squeezed (Frame 8)
	"", # 7: Satan tells you you are the supervisor (text box drawn?) (Frame 9)
	"", # Grab Clipboard (Frame 10)
]

var dialogue_lines := [
	"", # 1: Black Screen with Music (Frame 0?)
	"", # 2: Open w/ MC + Skelly (Frame 1)
	"(Chatter Noises)", # 3.1: Satan Talks (Frame 2)
	"Hey man, I don’t know why you insist on calling me everyday to talk about this shit. I know what I’m doing.", # 3.2: Skelly Responds (Frame 3)
	"Ugh, fine, I’ll review, happy? Absolutely no one here wants to do their job, but the longer shit doesn’t get done the more our Satan Approved Productivity Meter™ falls. If it hits zero, the manager on shift gets fired, so that’d be me.", # 3.3 Skelly continues (Frame 4)
	"To get people to do their damn jobs, there are two ways HR has approved of. Persuasion, or Intimidation. You press “O” to intimidate someone, and “P” to persuade, all your shit is in your inventory which is obviously under “I” and in case you’ve never spoken to someone before and you need that refresher too, you interact with “E”.  Get off my back.", # 3.4: Skelly Tutorial (Frame 5)
	"", # 4: Pause (Frame 6)
	"", # 5: Satan Grabs Through Phone (Frame 7)
	"", # 6: Skelly is Squeezed (Frame 8)
	"", # 7: Satan tells you you are the supervisor (text box drawn?) (Frame 9)
	"" # Grab Clipboard (Frame 10)
]

func _ready():
	slideshow.animation = "cutscene"
	slideshow.frame = current_frame
	dialogue_label.text = dialogue_lines[current_frame]
	name_label.text = name_lines[current_frame]
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		current_frame += 1
		if current_frame < slideshow.sprite_frames.get_frame_count("cutscene"):
			slideshow.frame = current_frame
			if current_frame < dialogue_lines.size():
				dialogue_label.text = dialogue_lines[current_frame]
				name_label.text = name_lines[current_frame]
			else:
				dialogue_label.text = ""
				name_label.text = ""
		else:
			await SceneTransition.change_scene_with_fade("res://Map.tscn")
