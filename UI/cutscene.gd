extends Control

@onready var slideshow = $Slideshow
@onready var dialogue_label = $DialogueLabel
@onready var name_label = $NameLabel
@onready var animationbg = $AnimationBG
@onready var talksprites = $TalkSprites
@onready var stilldialogue = $StillDialogue
@onready var satantext = $SatanText

var shots = ["shot1", "shot1", "shot1", "shot1", "shot1", "shot1", "shot1", "shot3", "shot4", "shot5", "shot6", "shot6", "shot6", "shot6"]
var wait_for_input_at = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]  # indices in `shots` to pause after
var current_shot_index := 0
var waiting_for_input := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	talksprites.visible = false
	satantext.visible = false
	play_current_shot()

func play_current_shot():
	var shot_name = shots[current_shot_index]
	slideshow.play(shot_name)

	if current_shot_index in wait_for_input_at:
		# Don't wait for animation_finished — looped animations never emit it
		waiting_for_input = true
	else:
		# Only connect to animation_finished if it's not a looping shot
		slideshow.connect("animation_finished", Callable(self, "_on_shot_finished"), ConnectFlags.CONNECT_ONE_SHOT)

func _on_shot_finished():
	if current_shot_index in wait_for_input_at:
		waiting_for_input = true
	else:
		next_shot()

func next_shot():
	current_shot_index += 1
	
	if current_shot_index >= shots.size():
		await SceneTransition.change_scene_with_fade("res://Map.tscn")
		return

	match current_shot_index:
		0:
			name_label.text = ""
			dialogue_label.text = ""
		1:
			talksprites.visible = true
			talksprites.play("slidein")
			name_label.text = "Satan"
			dialogue_label.text = "(Chatter Noises)"
		2:
			name_label.text = "Skelly"
			dialogue_label.text = "Hey man, I don’t know why you insist on calling me everyday to talk about this shit. I know what I’m doing."		
		3: 
			name_label.text = "Skelly"
			dialogue_label.text = "Ugh, fine, I’ll review, happy? Absolutely no one here wants to do their job, but the longer shit doesn’t get done the more our Satan Approved Productivity Meter™ falls."
		4:
			name_label.text = "Skelly"
			dialogue_label.text = "If it hits zero, the manager on shift gets fired, so that’d be me."
		5:
			name_label.text = "Skelly"
			dialogue_label.text = "To get people to do their damn jobs, there are two ways HR has approved of. Persuasion, or Intimidation. You press “O” to intimidate someone, and “P” to persuade."
		6:	
			name_label.text = "Skelly"
			dialogue_label.text = "All your shit is in your inventory which is obviously under “I” and in case you’ve never spoken to someone before and you need that refresher too, you interact with “E”.  Get off my back."
		7:
			talksprites.play("slideout")
			name_label.text = ""
			dialogue_label.text = ""
		8:
			name_label.text = ""
			dialogue_label.text = ""
			print("THIS IS 8")
		9:
			satantext.visible = true
			satantext.text = "That guy is always sooo negative, I mean, c’mon! It’s Hell! Lighten up!"
		10:
			satantext.text = "You! I can hear feet shuffling, who's standing there? An Intern? Whoever it is, congratulations! I still need someone to do his job, so it’s yours now!"
		11:
			satantext.text = "If you can survive in this new position for the day you’ll get the promotion officially. If not, you and Skelly can catch up in Limbo. Sounds good?"
		12:
			satantext.text = " Fabulous! I’m sure you’re nodding enthusiastically. Well, get to it! Keep an eye on that meter,  or I’ll be seeing you much sooner. Goodbye!"
		_:
			name_label.text = ""
			dialogue_label.text = ""

	play_current_shot()



func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and waiting_for_input:
		waiting_for_input = false
		next_shot()


#extends Control
#
#@onready var slideshow = $Slideshow
#@onready var dialogue_label = $DialogueLabel
#@onready var name_label = $NameLabel
#@onready var animationbg = $AnimationBG
#
#var current_frame := 0
#
#var name_lines := [
	#"", # 1: Black Screen with Music (Frame 0)
	#"", # 2: Open w/ MC + Skelly (Frame 1)
	#"Satan", # 3.1: Satan Talks (Frame 2)
	#"Skelly", # 3.2: Skelly Responds (Frame 3)
	#"Skelly", # 3.3: Skelly Continues (Frame 4)
	#"Skelly", # 3.4: Skelly Tutorial (Frame 5)
	#"", # 4: Pause (Frame 6)
	#"", # 5: Satan Grabs Through Phone (Frame 7)
	#"", # 6: Skelly is Squeezed (Frame 8)
	#"", # 7: Satan tells you you are the supervisor (text box drawn?) (Frame 9)
	#"", # Grab Clipboard (Frame 10)
#]
#
#var dialogue_lines := [
	#"", # 1: Black Screen with Music (Frame 0?)
	#"", # 2: Open w/ MC + Skelly (Frame 1)
	#"(Chatter Noises)", # 3.1: Satan Talks (Frame 2)
	#"Hey man, I don’t know why you insist on calling me everyday to talk about this shit. I know what I’m doing.", # 3.2: Skelly Responds (Frame 3)
	#"Ugh, fine, I’ll review, happy? Absolutely no one here wants to do their job, but the longer shit doesn’t get done the more our Satan Approved Productivity Meter™ falls. If it hits zero, the manager on shift gets fired, so that’d be me.", # 3.3 Skelly continues (Frame 4)
	#"To get people to do their damn jobs, there are two ways HR has approved of. Persuasion, or Intimidation. You press “O” to intimidate someone, and “P” to persuade, all your shit is in your inventory which is obviously under “I” and in case you’ve never spoken to someone before and you need that refresher too, you interact with “E”.  Get off my back.", # 3.4: Skelly Tutorial (Frame 5)
	#"", # 4: Pause (Frame 6)
	#"", # 5: Satan Grabs Through Phone (Frame 7)
	#"", # 6: Skelly is Squeezed (Frame 8)
	#"", # 7: Satan tells you you are the supervisor (text box drawn?) (Frame 9)
	#"" # Grab Clipboard (Frame 10)
#]
#
#func _ready():
	#animationbg.play()
	#slideshow.animation = "cutscene"
	#slideshow.frame = current_frame
	#dialogue_label.text = dialogue_lines[current_frame]
	#name_label.text = name_lines[current_frame]
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
#func _unhandled_input(event):
	#if event.is_action_pressed("ui_accept"):
		#current_frame += 1
		#if current_frame < slideshow.sprite_frames.get_frame_count("cutscene"):
			#slideshow.frame = current_frame
			#if current_frame < dialogue_lines.size():
				#dialogue_label.text = dialogue_lines[current_frame]
				#name_label.text = name_lines[current_frame]
			#else:
				#dialogue_label.text = ""
				#name_label.text = ""
		#else:
			#await SceneTransition.change_scene_with_fade("res://Map.tscn")
