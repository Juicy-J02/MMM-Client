extends Control

const MAIN_MENU_SCENE_PATH = "res://Scenes/MainMenu.tscn"

@onready var deck = $HBoxContainer/MarginContainer2/VBoxContainer/DeckCards
@onready var collection = $HBoxContainer/MarginContainer2/VBoxContainer/ScrollContainer

func _ready():
	deck.show()
	collection.show()

func _on_back_button_pressed():
	http.update_deck(Global.deck, Global.combo_character)
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)

func _on_deck_button_pressed():
	deck._ready()
	deck.show()

func _on_collection_button_pressed():
	deck.clear_deck()
	deck.hide()
