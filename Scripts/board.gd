extends Node2D

const BOARD_WIDTH = 6
const BOARD_HEIGHT = 6

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var player1_deck = Global.deck

var board_cards = []

var board = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var board_deck = player1_deck
	create_board_cards(board_deck)
	board_cards.shuffle()
	board = create_board(BOARD_WIDTH, BOARD_HEIGHT, board, board_cards)


func create_board_cards(board_deck):
	var board_value = 0
	var card_scene = preload(CARD_SCENE_PATH)
	for i in board_deck:
		var new_card_1 = card_scene.instantiate()
		var new_card_2 = card_scene.instantiate()
		new_card_1.get_node("CardFront").texture = load("res://Assets/CardArt/" + i + ".png")
		new_card_1.value_on_card = board_value
		new_card_2.get_node("CardFront").texture = load("res://Assets/CardArt/" + i + ".png")
		new_card_2.value_on_card = board_value
		board_value += 1
		board_cards.append(new_card_1)
		board_cards.append(new_card_2)


func create_board(rows, columns, board, board_cards):
	var card_index = 0
	for i in range(rows):
		for j in range(columns):
			if card_index < board_cards.size():
				var new_card = board_cards[card_index]
				new_card.position = Vector2((i * 200) + 460, (j * 150) + 150)
				add_child(new_card)
				board.append(new_card)
				card_index += 1
	return board
