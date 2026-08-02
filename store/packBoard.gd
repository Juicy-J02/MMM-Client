extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

const PACK_SIZE = 16
const COIN_CHANCE = 45
const RARITY_CHANCES = {
	"common": 70.0,
	"rare": 25.0,
	"epic": 5.0,
}

var cols
var rows

var cell_width
var cell_height
var board_padding = 30
var board_size

var card_scene = preload(CARD_SCENE_PATH)

var card_nodes = []
var board = []

func _ready():
	get_parent().resized.connect(draw_board)
	
	var board_deck = create_pack()
	create_pack_data(board_deck)
	draw_board()

func draw_board():
	clear_board()

	var card_count = board.size()
	if card_count == 0:
		return

	var grid_size = get_grid_size(card_count)
	cols = grid_size.x
	rows = grid_size.y

	var panel_size = get_parent().size

	var board_origin = Vector2(board_padding, board_padding)
	board_size = Vector2(panel_size.x - (board_padding * 2), panel_size.y - (board_padding * 2))

	cell_width = board_size.x / cols
	cell_height = board_size.y / rows

	for i in range(card_count):
		var card_info = board[i]

		if card_info["matched"]:
			continue

		var new_card = card_scene.instantiate()
		add_child(new_card)
		
		if card_info["type"] == "currency":
			var texture_path = "res://Assets/StoreArt/" + card_info["art"] + ".png"
			new_card.get_node("CardFront").texture = load(texture_path)
		else:
			var texture_path = "res://Assets/CardArt/" + card_info["art"] + ".png"
			new_card.get_node("CardFront").texture = load(texture_path)
		
		new_card.set_selected(card_info["selected"])
		new_card.set_matched(card_info["matched"])
		new_card.value_on_card = card_info["board_value"]
		new_card.type = card_info["type"]
		
		new_card.update_visual()

		var col = i % cols
		var row = int(i / cols)

		new_card.position = board_origin + Vector2((col * cell_width) + (cell_width / 2),(row * cell_height) + (cell_height / 2))

		var scale_factor = min(cell_width / 200.0, cell_height / 150.0) * 0.75
		new_card.scale = Vector2(scale_factor, scale_factor)

		card_nodes.append(new_card)

func get_grid_size(card_count: int):
	var column = int(ceil(sqrt(card_count)))
	var row = int(ceil(float(card_count) / float(column)))
	return Vector2i(column, row)

func create_pack():
	var board_deck = []
	
	for i in range(PACK_SIZE / 2):
		if randf_range(0.0, 100.0) < COIN_CHANCE:
			board_deck.append({
				"reward_type": "coins",
			})
			board_deck.append({
				"reward_type": "coins",
			})
		else:
			var rarity = roll_rarity()
			var card_name = get_random_card_by_rarity(rarity)
			if card_name != "":
				board_deck.append({
					"reward_type": "card",
					"card_name": card_name,
				})
				board_deck.append({
					"reward_type": "card",
					"card_name": card_name,
				})

	return board_deck

func roll_rarity():
	var roll = randf_range(0.0, 100.0)
	var current_chance = 0.0

	for rarity in RARITY_CHANCES:
		current_chance += RARITY_CHANCES[rarity]

		if roll < current_chance:
			return rarity

	return "common"


func get_random_card_by_rarity(rarity):
	var possible_cards = []

	for card_name in CardDatabase.CARDS:
		var card_data = CardDatabase.CARDS[card_name]

		if card_data.get("rarity", "") == rarity:
			possible_cards.append(card_name)

	if possible_cards.is_empty():
		return ""

	return possible_cards.pick_random()

func create_pack_data(board_deck):
	board.clear()

	for reward in board_deck:
		if reward["reward_type"] == "coins":
			board.append({
				"id": board.size(),
				"board_value": "Coin",
				"art": "Coin",
				"type": "currency",
				"card_type": null,
				"action_type": null,
				"selected": false,
				"matched": false,
			})
		else:
			var card_name = reward["card_name"]
			var card_data = CardDatabase.CARDS[card_name]

			board.append({
				"id": board.size(),
				"board_value": card_name,
				"art": card_name,
				"type": card_data["type"],
				"card_type": card_data["card_type"],
				"action_type": card_data["action_type"],
				"rarity": card_data["rarity"],
				"selected": false,
				"matched": false,
			})

	board.shuffle()

func clear_board():
	for card in card_nodes:
		if is_instance_valid(card):
			card.queue_free()
	
	card_nodes.clear()
