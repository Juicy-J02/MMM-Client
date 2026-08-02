extends Control

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const BOARD_PADDING = 5
const CARD_SCALE  = .75
const CARD_WIDTH = 150
const NORMAL_GAP = 20
const MIN_GAP = 35

@onready var combo_cards1_container = $VBoxContainer/HBoxContainer
@onready var combo_cards2_container = $VBoxContainer/HBoxContainer2

var card_scene = preload(CARD_SCENE_PATH)
var combo_card_nodes = []

func _ready():
	ws.combo_update_sig.connect(_on_combo_update)
	await get_tree().process_frame
	_on_combo_update()

func _on_combo_update():
	if Game.combo_characters.size() == 0:
		hide()
	else:
		show()
		draw_combos(Game.combo_characters)

func draw_combos(combo_characters):
	clear_combo_cards()

	if combo_characters.size() >= 1:
		draw_combo_row(combo_cards1_container, [
			{"name": combo_characters[0].combo_cards.card1, "matched": combo_characters[0].card1_matched[0]},
			{"name": combo_characters[0].combo_cards.card2, "matched": combo_characters[0].card2_matched[0]}
		])

	if combo_characters.size() >= 2:
		draw_combo_row(combo_cards2_container, [
			{"name": combo_characters[1].combo_cards.card1, "matched": combo_characters[1].card1_matched[0]},
			{"name": combo_characters[1].combo_cards.card2, "matched": combo_characters[1].card2_matched[0]}
		])

func draw_combo_row(container, cards):
	var card_count = cards.size()
	if card_count == 0:
		return

	var container_size = container.size
	var usable_width = container_size.x - (BOARD_PADDING * 2)

	var scaled_card_width = CARD_WIDTH * CARD_SCALE
	var normal_spacing = scaled_card_width + NORMAL_GAP

	var spacing = normal_spacing
	var needed_width = scaled_card_width + ((card_count - 1) * normal_spacing)

	if needed_width > usable_width:
		spacing = (usable_width - scaled_card_width) / max(card_count - 1, 1)
		spacing = max(spacing, MIN_GAP)

	var total_width = scaled_card_width + ((card_count - 1) * spacing)
	var x_start = (container_size.x / 2) - (total_width / 2) + (scaled_card_width / 2)
	var y_pos = container_size.y / 2

	for i in range(card_count):
		var card_info = cards[i]
		var card_name = card_info.name

		var new_card = card_scene.instantiate()
		new_card.card_name = card_name
		new_card.get_node("CardFront").texture = load("res://Assets/CardArt/" + card_name + ".png")

		new_card.set_selected(true)
		new_card.set_matched(false)
		
		if card_info.matched:
			new_card.modulate = Color(0.4, 0.4, 0.4)

		new_card.scale = Vector2(CARD_SCALE, CARD_SCALE)
		new_card.position = Vector2(x_start + (i * spacing), y_pos)

		container.add_child(new_card)
		combo_card_nodes.append(new_card)

func clear_combo_cards():
	for card in combo_card_nodes:
		if is_instance_valid(card):
			card.queue_free()

	combo_card_nodes.clear()
