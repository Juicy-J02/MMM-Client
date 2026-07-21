extends Control

@onready var tap_off_button = $TapOffButton
@onready var tap_off_timer = $TapOffTimer

var tap_value
var tap_trigger

func _ready():
	ws.tap_off_sig.connect(tap_off)
	tap_off_button.hide()
	tap_value = 0

func tap_off(turn, time, trigger):
	if turn == Game.turn:
		Game.input_blocked = true
		tap_off_button.show()
		tap_off_timer.wait_time = time
		tap_trigger = trigger
		tap_off_timer.start()

func _on_tap_off_button_pressed():
	tap_value += 1
	if tap_trigger > 0 and tap_value % tap_trigger == 0:
		ws.send_json({
			"type": "tap_trigger",
			"gameId": Game.current_game_id,
			"value": tap_value / tap_trigger
		})

func _on_timer_timeout():
	tap_off_button.hide()
	tap_off_timer.stop()
	
	ws.send_json({
		"type": "tap_off",
		"gameId": Game.current_game_id,
		"tapValue": tap_value
	})
	
	Game.input_blocked = false
	tap_value = 0
