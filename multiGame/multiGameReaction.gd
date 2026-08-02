extends Control

@onready var timer = $Timer

var reaction_types = []

signal reaction_input_sig

func _ready():
	ws.reaction_sig.connect(reaction)
	ws.reaction_success_sig.connect(reaction_success)
	ws.end_turn_sig.connect(clear_reaction_end_turn)
	hide()

func reaction(turn, type):
	if turn != Game.turn:
		return

	reaction_types.append(type)
	Game.matching_blocked = true
	Game.actions_blocked = true
	Game.reaction_blocked = false
	timer.start()
	show()
	
	reaction_input_sig.emit()

func reaction_success(type):
	clear_reaction(type)

func _on_timer_timeout():
	for reaction_type in reaction_types:
		ws.send_json({
			"type": "reaction_failed",
			"gameId": Game.current_game_id,
			"reaction_type": reaction_type,
		})
	
		clear_reaction(reaction_type)

func clear_reaction(type):
	reaction_types.erase(type)
	
	if not reaction_types.is_empty():
		reaction_input_sig.emit()
		return
		
	Game.matching_blocked = false
	Game.actions_blocked = false
	Game.reaction_blocked = true
	timer.stop()
	hide()

func clear_reaction_end_turn():
	if reaction_types.has("Discard"):
		return

	for reaction_type in reaction_types:
		clear_reaction(reaction_type)

func can_play_reaction(action_name):
	if action_name == "RogueBandit":
		return reaction_types.has("Start Turn")
	elif  action_name == "RogueBerserker":
		return reaction_types.has("Match")
	elif  action_name == "RogueWarlock":
		return reaction_types.has("Discard")
	elif  action_name == "Slide":
		return reaction_types.has("Jump")
	elif  action_name == "Slither":
		return reaction_types.has("Slide")
	elif action_name == "BuffUp":
		return reaction_types.has("Lose Turn")
	else:
		return false
