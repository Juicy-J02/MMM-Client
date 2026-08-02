extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const MAX_COLS := 6
const MAX_ROWS := 3

var cols
var rows

var cell_width
var cell_height
var board_padding = 30
var board_size
var card_scene = preload(CARD_SCENE_PATH)

@onready var game = get_tree().current_scene

func _ready():
	get_parent().resized.connect(draw_board)
	create_board_data()
	draw_board()

func create_board_data():
	Game.board.clear()
	Game.matching_blocked = false

	for i in Global.deck:
		Game.board.append({
			"id": Game.board.size(),
			"board_value": i,
			"art": i,
			"type": CardDatabase.CARDS[i].type,
			"card_type": CardDatabase.CARDS[i].card_type,
			"action_type": CardDatabase.CARDS[i].action_type,
			"selected": false,
			"matched": false,
			"burned": {"active": false, "timer": 0},
			"frozen": {"active": false, "timer": 0},
			"poisoned": [false, 0],
			"slimed": [false, 0],
			"shocked": [false, 0],
			"charge": [false, 0],
			"highlight": false,
			"revealed": false,
			"protected": false,
		})

		Game.board.append({
			"id": Game.board.size(),
			"board_value": i,
			"art": i,
			"type": CardDatabase.CARDS[i].type,
			"card_type": CardDatabase.CARDS[i].card_type,
			"action_type": CardDatabase.CARDS[i].action_type,
			"selected": false,
			"matched": false,
			"burned": {"active": false, "timer": 0},
			"frozen": {"active": false, "timer": 0},
			"poisoned": [false, 0],
			"slimed": [false, 0],
			"shocked": [false, 0],
			"charge": [false, 0],
			"highlight": false,
			"revealed": false,
			"protected": false,
		})

	Game.board.shuffle()

func draw_board():
	clear_board()

	var card_count = Game.board.size()
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
		var card_info = Game.board[i]

		if card_info["matched"]:
			continue

		var new_card = card_scene.instantiate()
		add_child(new_card)

		new_card.card_id = card_info["id"]
		new_card.type = card_info["type"]
		new_card.card_type = card_info["card_type"]
		new_card.action_type = card_info["action_type"]
		new_card.value_on_card = card_info["board_value"]

		var texture_path = "res://Assets/CardArt/" + card_info["art"] + ".png"
		new_card.get_node("CardFront").texture = load(texture_path)

		var show_poison = card_info["poisoned"][0] and card_info["poisoned"][1] == Game.turn
		new_card.set_poisoned(show_poison)

		var show_slime = card_info["slimed"][0] and card_info["slimed"][1] == Game.turn
		new_card.set_slimed(show_slime)

		var show_shock = card_info["shocked"][0] and card_info["shocked"][1] == Game.turn
		new_card.set_slimed(show_shock)

		new_card.set_burned(card_info["burned"].active)
		new_card.set_frozen(card_info["frozen"].active)
		new_card.set_revealed(card_info["revealed"])

		new_card.set_protected(card_info["protected"])

		new_card.set_selected(card_info["selected"])
		new_card.set_matched(card_info["matched"])
		
		new_card.update_visual()

		var col = i % cols
		var row = int(i / cols)

		new_card.position = board_origin + Vector2((col * cell_width) + (cell_width / 2),(row * cell_height) + (cell_height / 2))

		var scale_factor = min(cell_width / 200.0, cell_height / 150.0) * 0.75
		new_card.scale = Vector2(scale_factor, scale_factor)

		game.card_nodes[new_card.card_id] = new_card

func get_grid_size(card_count: int):
	if card_count > MAX_COLS * MAX_ROWS:
		card_count = MAX_COLS * MAX_ROWS

	var column = min(MAX_COLS, int(ceil(float(card_count) / MAX_ROWS)))
	var row = int(ceil(float(card_count) / column))

	return Vector2i(column, row)

func clear_board():
	for card in game.card_nodes.values():
		if is_instance_valid(card):
			card.queue_free()
	
	game.card_nodes.clear()
