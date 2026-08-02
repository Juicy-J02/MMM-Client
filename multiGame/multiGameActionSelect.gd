extends Control

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const COMBO_SCENE_PATH = "res://Scenes/ComboCard.tscn"
const BOARD_PADDING = 5
const CARD_SCALE  = 1
const CARD_HEIGHT = 150
const COMBO_HEIGHT = 300
const NORMAL_GAP = 20
const MIN_GAP = 35

@onready var panel = $Panel

var card_scene = preload(CARD_SCENE_PATH)
var combo_scene = preload(COMBO_SCENE_PATH)
var action_card_nodes = []

func _ready():
	self.hide()

func draw_actions(actions):
	clear_action_cards()

	var card_count = actions.size()
	if card_count == 0:
		return

	var panel_size = panel.size
	var usable_height = panel_size.y - (BOARD_PADDING * 2)
	var x_pos = panel_size.x / 2

	var total_base_height = 0.0

	for action_info in actions:
		if action_info["type"] == "combo character":
			total_base_height += COMBO_HEIGHT
		else:
			total_base_height += CARD_HEIGHT

	total_base_height += NORMAL_GAP * (card_count - 1)

	var scale_factor = 1.0

	if total_base_height > usable_height:
		scale_factor = usable_height / total_base_height

	var gap = NORMAL_GAP * scale_factor
	var total_height = total_base_height * scale_factor
	var y_pos = BOARD_PADDING + ((usable_height - total_height) / 2)

	for i in range(card_count):
		var action_info = actions[i]
		var new_card
		var base_height

		if action_info["type"] == "combo character":
			new_card = combo_scene.instantiate()
			base_height = COMBO_HEIGHT
		else:
			new_card = card_scene.instantiate()
			base_height = CARD_HEIGHT

		var card_height = base_height * scale_factor

		new_card.card_name = action_info["board_value"]
		new_card.value_on_card = action_info["id"]
		new_card.type = action_info["type"]
		new_card.action_type = action_info["action_type"]
		new_card.get_node("CardFront").texture = load("res://Assets/CardArt/" + action_info["art"] + ".png")

		new_card.set_selected(true)
		new_card.set_matched(false)

		new_card.scale = Vector2(CARD_SCALE * scale_factor, CARD_SCALE * scale_factor)

		new_card.position = Vector2(
			x_pos,
			y_pos + (card_height / 2)
		)

		new_card.z_index = i

		panel.add_child(new_card)
		action_card_nodes.append(new_card)

		y_pos += card_height + gap

func is_point_inside_panel(point):
	return panel.get_global_rect().has_point(point)

func clear_action_cards():
	for card in action_card_nodes:
		if is_instance_valid(card):
			card.queue_free()

	action_card_nodes.clear()
