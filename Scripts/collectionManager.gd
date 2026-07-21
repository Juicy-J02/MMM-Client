extends Node2D

signal update_deck_sig

@onready var input_manager = $"../InputManager"

func _ready():
	input_manager.left_click_card_sig.connect(update_deck)

func update_deck(card):
	var path = card.get_node("CardFront").texture.resource_path.get_basename().get_file()

	if path in Global.deck:
		Global.deck.erase(path)
	elif Global.deck.size() < 9:
		Global.deck.append(path)

	if Global.deck.size() > 1:
		if Global.deck.has("BuffUp") and Global.deck.has("Skeleton"):
			Global.combo_character = "Skele-TON"
		elif Global.deck.has("FireSpirit") and Global.deck.has("IceSpirit"):
			Global.combo_character = "Chilly"
		else:
			Global.combo_character = ""
	else:
		Global.combo_character = ""

	update_deck_sig.emit()
	
