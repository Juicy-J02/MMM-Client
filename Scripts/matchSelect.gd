extends Control

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const COMBO_SCENE_PATH = "res://Scenes/ComboCard.tscn"
const BOARD_PADDING = 5
const CARD_SCALE  = 1
const CARD_HEIGHT = 150
const COMBO_HEIGHT = 300
const NORMAL_GAP = 20
const MIN_GAP = 10

@onready var panel = $Panel

var card_scene = preload(CARD_SCENE_PATH)
var combo_scene = preload(COMBO_SCENE_PATH)
var match_card_nodes = []

#func _ready():
	#self.hide()

func draw_matches(matches):
	clear_match_cards()

	var card_count = matches.size()
	if card_count == 0:
		return

	var panel_size = panel.size
	var usable_height = panel_size.y - (BOARD_PADDING * 2)
	var x_pos = panel_size.x / 2

	var total_base_height = 0.0

	for match_info in matches:
		if match_info["type"] == "combo":
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
		var match_info = matches[i]
		var new_card
		var base_height
		
		print("Match Info")
		print("")
		print(match_info)

		if match_info["type"] == "combo":
			new_card = combo_scene.instantiate()
			base_height = COMBO_HEIGHT
		else:
			new_card = card_scene.instantiate()
			base_height = CARD_HEIGHT

		var card_height = base_height * scale_factor

		new_card.card_name = match_info["board_value"]
		new_card.card_id = match_info["id"]
		new_card.type = match_info["type"]
		new_card.card_type = match_info["card_type"]
		new_card.action_type = match_info["action_type"]
		new_card.score = match_info["score"]
		var charge = match_info["charge"]
		new_card.charge[0] = charge[0]
		new_card.charge[1] = charge[1]
		new_card.get_node("CardFront").texture = load("res://Assets/CardArt/" + match_info["art"] + ".png")

		new_card.set_protected(match_info["protected"])
		new_card.set_selected(true)
		new_card.set_matched(false)

		new_card.z_index = 2

		panel.add_child(new_card)
		new_card.position = Vector2(x_pos, y_pos + (card_height / 2))
		new_card.scale = Vector2(CARD_SCALE * scale_factor, CARD_SCALE * scale_factor)
		match_card_nodes.append(new_card)

		y_pos += card_height + gap

func is_point_inside_panel(point):
	return panel.get_global_rect().has_point(point)

func clear_match_cards():
	for card in match_card_nodes:
		if is_instance_valid(card):
			card.queue_free()

	match_card_nodes.clear()
