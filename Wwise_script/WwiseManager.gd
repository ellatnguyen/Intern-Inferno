extends Node

#class_name WwiseManager

func _ready():
	# Register this manager as the listener and game object
	Wwise.register_game_obj(self, "WwiseManager")
	Wwise.register_listener(self)

	# Load the music bank
	Wwise.load_bank_id(AK.BANKS.WORK_YOURSELF_TO_DEATH_MUSIC)

func play_event(event_id: int, game_obj: Node = self):
	if game_obj:
		Wwise.post_event_id(event_id, game_obj)
	else:
		Wwise.post_event_id(event_id, self)

func set_rtpc(rtpc_id: int, value: float, game_obj: Node = self):
	Wwise.set_rtpc_value_id(rtpc_id, value, game_obj)

func trigger_damage_buff(on: bool, game_obj: Node):
	play_event(AK.EVENTS.DAMAGE_BUFF_ON if on else AK.EVENTS.DAMAGE_BUFF_OFF, game_obj)

func trigger_energy_drink(on: bool, game_obj: Node):
	play_event(AK.EVENTS.ENERGY_DRINK_ON if on else AK.EVENTS.ENERGY_DRINK_OFF, game_obj)

func trigger_xp_boost(on: bool, game_obj: Node):
	play_event(AK.EVENTS.XP_BOOST_ON if on else AK.EVENTS.XP_BOOST_OFF, game_obj)

func trigger_lifesparer(game_obj: Node):
	play_event(AK.EVENTS.LIFESPARER_ON, game_obj)

func trigger_intimidation(game_obj: Node):
	play_event(AK.EVENTS.INTIMIDATION, game_obj)

func trigger_persuasion(game_obj: Node):
	play_event(AK.EVENTS.PERSUASION, game_obj)

func set_music_state(state_id: int):
	Wwise.set_state_id(AK.STATES.MUSIC_STATE.GROUP, state_id)

func set_menu_state(in_menu: bool):
	var state = AK.STATES.MENU_STATE.STATE.IN_MENU if in_menu else AK.STATES.MENU_STATE.STATE.OUT_OF_MENU
	Wwise.set_state_id(AK.STATES.MENU_STATE.GROUP, state)

func start_game():
	# Sequence when game boots up
	Wwise.set_switch_id(AK.SWITCHES.LIFE.GROUP, AK.SWITCHES.LIFE.SWITCH.ALIVE, self)
	set_music_state(AK.STATES.MUSIC_STATE.STATE.TITLE_THEME)
	set_menu_state(false)
	play_event(AK.EVENTS.GAME_START)

func play_overworld_music():
	set_music_state(AK.STATES.MUSIC_STATE.STATE.OVERWORLD)
	play_event(AK.EVENTS.OVERWORLD)

func play_battle_music():
	set_music_state(AK.STATES.MUSIC_STATE.STATE.BATTLES)
	play_event(AK.EVENTS.BATTLES)

func play_cutscene_music():
	set_music_state(AK.STATES.MUSIC_STATE.STATE.CUTSCENE)
	play_event(AK.EVENTS.CUTSCENE)

func play_credits_music():
	set_music_state(AK.STATES.MUSIC_STATE.STATE.CREDITS)
	play_event(AK.EVENTS.CREDITS)

func play_victory_music():
	set_music_state(AK.STATES.MUSIC_STATE.STATE.VICTORY)
	play_event(AK.EVENTS.VICTORY)

func play_defeated_music():
	play_event(AK.EVENTS.DEFEATED)

func finish_game():
	play_event(AK.EVENTS.GAME_FINISHED)

func set_timer_value(value: float):
	set_rtpc(AK.GAME_PARAMETERS.TIMER, value)

func apply_sidechain():
	play_event(AK.EVENTS.SIDECHAIN)

# Optional helper for menus
func enter_menu():
	set_menu_state(true)
	play_event(AK.EVENTS.IN_MENU)

func exit_menu():
	set_menu_state(false)
	play_event(AK.EVENTS.OUT_OF_MENU)
