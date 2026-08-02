extends Control

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var deck = []

@onready var container = $VBoxContainer/HBoxContainer
@onready var card_manager = $"../../../../CardManager"

func _ready():
	card_manager.update_deck_sig.connect(update_deck_visuals)
	update_deck_visuals()

func create_deck_cards():
	var card_scene = preload(CARD_SCENE_PATH)
	var created_cards = []

	for i in Global.deck:
		var card = card_scene.instantiate()
		card.get_node("CardFront").texture = load("res://Assets/CardArt/" + i + ".png")
		card.card_name = i
		created_cards.append(card)

	return created_cards

func draw_deck(cards):
	clear_deck()
	var card_index = 0

	for i in range(cards.size()):
		var new_card = cards[card_index]
		new_card.scale = Vector2(1.5, 1.5)
		new_card.selected = true
		container.add_child(new_card)
		deck.append(new_card)

		if card_index < 5:
			new_card.position = Vector2((i * 250) + 200, 200)
		else:
			new_card.position = Vector2(((i - 4) * 250) + 75, 400)

		card_index += 1

func update_deck_visuals():
	var cards = create_deck_cards()
	draw_deck(cards)

func clear_deck():
	deck.clear()
	for card in container.get_children():
		card.queue_free()
