extends Control

@onready var tap_off_timer = $TapOffTimer
@onready var sprite = $AnimatedSprite2D
@onready var button = $Button
@onready var tap_mask = $TapMask
@onready var tap_label = $TapLabel

var tap_value
var tap_trigger
var action_value
var bounce_tween

var action_stage_counts := {
	"Drill": 6,
	"Skele-TON": 3,
}

func _ready():
	ws.tap_off_sig.connect(tap_off)
	hide()
	tap_mask.hide()
	tap_label.hide()

func tap_off(turn, time, trigger, action):
	if turn != Game.turn:
		return

	Game.matching_blocked = true
	Game.actions_blocked = true
	show()
	tap_mask.show()
	tap_label.show()

	tap_value = 0
	tap_trigger = trigger
	action_value = action

	update_button_art()

	tap_off_timer.wait_time = time
	tap_off_timer.start()


func _on_button_pressed():
	tap_value += 1
	
	bounce()
	
	if tap_trigger > 0 and tap_value % tap_trigger == 0:
		update_button_art()
		ws.send_json({
			"type": "tap_trigger",
			"gameId": Game.current_game_id,
			"value": tap_value / tap_trigger,
			"action": action_value
		})

func bounce():
	if bounce_tween:
		bounce_tween.kill()

	bounce_tween = create_tween()
	bounce_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.05)
	bounce_tween.tween_property(self, "scale", Vector2(1, 1), 0.05)

func update_button_art():
	var max_stage = action_stage_counts.get(action_value) - 1
	var stage = min(int(tap_value / tap_trigger), max_stage) 

	var animation_name = "%s_%d" % [action_value, stage]

	if sprite.sprite_frames.has_animation(animation_name):
		sprite.play(animation_name)
	else:
		print("Missing animation: ", animation_name)

func _on_timer_timeout():
	hide()
	tap_mask.hide()
	tap_label.hide()
	tap_off_timer.stop()
	
	ws.send_json({
		"type": "tap_off",
		"gameId": Game.current_game_id,
		"tapValue": tap_value,
		"action": action_value
	})
	
	Game.matching_blocked = false
	Game.actions_blocked = false
	tap_value = 0
