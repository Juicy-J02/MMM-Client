extends Control

@onready var timer = $Timer

var reaction_type

signal reaction_input_sig

func _ready():
	ws.reaction_sig.connect(reaction)
	ws.reaction_success_sig.connect(reaction_success)
	ws.end_turn_sig.connect(clear_reaction)
	hide()

func reaction(turn, type):
	if turn != Game.turn:
		return

	reaction_type = type
	Game.matching_blocked = true
	Game.actions_blocked = true
	Game.reaction_blocked = false
	timer.start()
	show()
	
	reaction_input_sig.emit()

func reaction_success():
	clear_reaction()

func _on_timer_timeout():
	ws.send_json({
		"type": "reaction_failed",
		"gameId": Game.current_game_id,
		"reaction_type": reaction_type,
	})
	
	clear_reaction()

func clear_reaction():
	if reaction_type == "Lose Turn" or reaction_type == "Match" or reaction_type == "Jump" or reaction_type == "Slide":
		Game.matching_blocked = false
		Game.actions_blocked = false

	Game.reaction_blocked = true
	timer.stop()
	hide()
