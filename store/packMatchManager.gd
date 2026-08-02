extends Node2D

signal match_sig
signal update_matches_sig

@onready var card_manager = $"../CardManager"
@onready var pack = get_tree().current_scene

var clicked_cards

func _ready():
	card_manager.flip_sig.connect(calculate_move)
	clicked_cards = []

func calculate_move(card):
	clicked_cards.append(card)

	if clicked_cards.size() < 2:
		return

	for card1 in clicked_cards:
		for card2 in clicked_cards:
			if card1 == card2:
				continue
			else:
				if card1.value_on_card == card2.value_on_card:
					match_sig.emit([card1, card2])
					clicked_cards.erase(card1)
					clicked_cards.erase(card2)
					pack.collected_cards.append(card1)
					pack.matches += 1
					update_matches_sig.emit(pack.collected_cards)
