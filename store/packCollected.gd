extends Control

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const BOARD_PADDING = 5
const CARD_SCALE  = 1
const CARD_HEIGHT = 150
const COMBO_HEIGHT = 300
const NORMAL_GAP = 20
const MIN_GAP = 35

@onready var match_manager = $"../../../../MatchManager"

var card_scene = preload(CARD_SCENE_PATH)
var card_nodes = []

func _ready():
	match_manager.update_matches_sig.connect(draw_matches)

func draw_matches(cards):
	clear_action_cards()

	var card_count = cards.size()
	if card_count == 0:
		return

	var usable_height = size.y - (BOARD_PADDING * 2)
	var x_pos = size.x / 2

	var total_base_height = 0.0

	for card_info in cards:
		total_base_height += CARD_HEIGHT

	total_base_height += NORMAL_GAP * (card_count - 1)

	var scale_factor = 1.0

	if total_base_height > usable_height:
		scale_factor = usable_height / total_base_height

	var gap = NORMAL_GAP * scale_factor
	var total_height = total_base_height * scale_factor
	var y_pos = BOARD_PADDING + ((usable_height - total_height) / 2)

	for i in range(card_count):
		var card_info = cards[i]
		var card = card_scene.instantiate()

		card.value_on_card = card_info.value_on_card
		card.type = card_info.type

		var base_height = CARD_HEIGHT
		var card_height = base_height * scale_factor

		if card.type == "currency":
			var texture_path = "res://Assets/StoreArt/" + card.value_on_card + ".png"
			card.get_node("CardFront").texture = load(texture_path)
		else:
			var texture_path = "res://Assets/CardArt/" + card.value_on_card + ".png"
			card.get_node("CardFront").texture = load(texture_path)

		card.set_selected(true)
		card.set_matched(false)

		card.scale = Vector2(CARD_SCALE * scale_factor, CARD_SCALE * scale_factor)
		card.position = Vector2(
			x_pos,
			y_pos + (card_height / 2)
		)

		card.z_index = i

		add_child(card)
		card_nodes.append(card)

		y_pos += card_height + gap

func clear_action_cards():
	for card in card_nodes:
		if is_instance_valid(card):
			card.queue_free()

	card_nodes.clear()
