extends Node2D

signal match_sig
signal no_match_sig
signal update_score

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../CardManager".connect("move_sig", calculate_move)

func calculate_move(clicked_cards):
	for card1 in clicked_cards:
		for card2 in clicked_cards:
			if card1 == card2:
				continue
			else:
				if card1.value_on_card == card2.value_on_card:
					match_sig.emit(card1)
					match_sig.emit(card2)
					update_score.emit(1, 1)
				else:
					no_match_sig.emit(card1)
					no_match_sig.emit(card2)
				clicked_cards.clear()
