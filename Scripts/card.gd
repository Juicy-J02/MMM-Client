extends Node2D
class_name Card

var card_name
var action_type
var type
var card_type
var card_id
var value_on_card
var score := 0
var selected := false
var matched := false
var burned := [false, 0]
var frozen := [false, 0]
var poisoned := [false, 0]
var slimed := [false, 0]
var shocked := [false, 0]
var charge := [false, 0]
var highlight := false
var revealed := false
var protected := false

@onready var front = $CardFront
@onready var back = $CardBack
@onready var sprite = $AnimatedSprite2D
@onready var score_panel = $ScorePanel
@onready var score_label = $ScorePanel/Label
@onready var charge_panel = $ChargePanel
@onready var charge_1 = $ChargePanel/Charge1
@onready var charge_2 = $ChargePanel/Charge2
@onready var charge_3 = $ChargePanel/Charge3

func _ready():
	sprite.hide()
	score_panel.hide()
	charge_panel.hide()
	update_visual()

func show_front():
	front.z_index = 1
	back.z_index = 0

	back.modulate = "ffffff"

	if revealed:
		sprite.play("revealed")

	if burned[0]:
		front.modulate = "fe6c35"
	else:
		front.modulate = "ffffff"

func show_back():
	front.z_index = 0
	back.z_index = 1

	front.modulate = "ffffff"

	if frozen[0]:
		back.modulate = "9ddaff"
	elif poisoned[0]:
		back.modulate = "fe72ff"
	elif slimed[0]:
		back.modulate = "32c232"
	elif shocked[0]:
		back.modulate = "0275f4"
	else:
		back.modulate = "ffffff"

func set_selected(value: bool):
	selected = value
	update_visual()

func set_matched(value: bool):
	matched = value
	update_visual()

func set_poisoned(value: bool):
	poisoned[0] = value
	update_visual()

func set_slimed(value: bool):
	slimed[0] = value
	update_visual()

func set_shocked(value: bool):
	shocked[0] = value

func set_burned(value: bool):
	burned[0] = value
	update_visual()

func set_frozen(value: bool):
	frozen[0] = value
	update_visual()

func set_highlight(value: bool):
	highlight = value
	update_visual()

func set_revealed(value: bool):
	if revealed == value:
		return
	revealed = value
	if revealed:
		sprite.show()
		sprite.play("revealed")
	else:
		sprite.hide()
		sprite.stop()
	update_visual()

func set_protected(value: bool):
	protected = value
	update_visual()

func update_visual():
	if not is_node_ready():
		return

	if front == null or back == null:
		return

	if selected or burned[0] or revealed:
		show_front()
	else:
		show_back()

	if score > 0:
		score_label.text = str(score)
		score_panel.show()
		score_label.show()
		score_panel.z_index = front.z_index
		score_label.z_index = front.z_index
	else:
		score_panel.hide()
		score_label.hide()
	
	if charge[0]:
		charge_panel.show()
		if charge[1] == 0:
			charge_1.hide()
			charge_2.hide()
			charge_3.hide()
		if charge[1] == 1:
			charge_1.show()
			charge_2.hide()
			charge_3.hide()
		elif charge[1] == 2:
			charge_1.show()
			charge_2.show()
			charge_3.hide()
		elif charge[1] == 3:
			charge_1.show()
			charge_2.show()
			charge_3.show()
	else:
		charge_panel.hide()
