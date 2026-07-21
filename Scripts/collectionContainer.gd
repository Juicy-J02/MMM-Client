extends Control

const COLLECTION_WIDTH = 5
const COLLECTION_HEIGHT = 10
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var collection = []

var sort_variables = ["card_number", "type", "card_type"]
var sort_index = 0

@onready var container = $VBoxContainer
@onready var sort_button = $"../../../MarginContainer3/VBoxContainer/SortButton"
@onready var card_manager = $"../../../../CardManager"

func _ready():
	card_manager.update_deck_sig.connect(update_collection_visuals)
	var sorted_names = sort("card_number")
	sort_button.text = "Card Number"
	var cards = create_collection_cards(sorted_names)
	draw_collection(COLLECTION_WIDTH, COLLECTION_HEIGHT, cards)

func create_collection_cards(card_names):
	var card_scene = preload(CARD_SCENE_PATH)
	var created_cards = []

	for i in card_names:
		var card = card_scene.instantiate()
		card.get_node("CardFront").texture = load("res://Assets/CardArt/" + i + ".png")
		card.card_name = i
		created_cards.append(card)

	return created_cards

func draw_collection(columns, rows, cards):
	clear_collection()
	var card_index = 0

	for i in range(rows):
		for j in range(columns):
			if card_index < cards.size():
				var new_card = cards[card_index]
				new_card.position = Vector2((j * 250) + 200, (i * 200) + 200)
				new_card.scale = Vector2(1.5, 1.5)
				if new_card.card_name in Global.deck:
					new_card.modulate = Color(0.4, 0.4, 0.4) 
				new_card.selected = true
				container.add_child(new_card)
				collection.append(new_card)
				card_index += 1
	container.custom_minimum_size = Vector2((columns * 250) + 150, (rows * 200) + 200)

func sort(method):
	var names = CardDatabase.CARDS.keys()

	names.sort_custom(func(a, b):
		var a_value = CardDatabase.CARDS[a][method]
		var b_value = CardDatabase.CARDS[b][method]

		if a_value == null:
			a_value = "zzzzzz"
		if b_value == null:
			b_value = "zzzzzz"

		return a_value < b_value
	)

	return names

func update_collection_visuals():
	for card in collection:
		if card.card_name in Global.deck:
			card.modulate = Color(0.4, 0.4, 0.4) # darken
		else:
			card.modulate = Color(1, 1, 1) # normal

func _on_sort_button_pressed():
	sort_index += 1
	if (sort_index >= sort_variables.size()):
		sort_index = 0

	var sorted_names = sort(sort_variables[sort_index])
	var cards = create_collection_cards(sorted_names)
	if sort_variables[sort_index] == "card_number":
		sort_button.text = "Card Number"
	elif sort_variables[sort_index] == "type":
		sort_button.text = "Type"
	elif sort_variables[sort_index] == "card_type":
		sort_button.text = "Card Type"
	draw_collection(COLLECTION_WIDTH, COLLECTION_HEIGHT, cards)

func clear_collection():
	for card in container.get_children():
		card.queue_free()

	collection.clear()
