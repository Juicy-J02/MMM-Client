extends Control

const STORE_MENU_SCENE_PATH = "res://Scenes/StoreMenu.tscn"

@onready var pack = $HBoxContainer/MarginContainer/VBoxContainer/Pack
@onready var button = $Button
@onready var input_manager = $InputManager
@onready var card_manager = $CardManager
@onready var timer = $Timer

var collected_cards 
var match_limit
var matches 

func _ready():
	input_manager.blocked = true
	card_manager.match_sig.connect(match_limit_check)
	pack.hide()

	collected_cards = []
	match_limit = 4
	matches = 0

func _on_button_pressed():
	pack.show()
	input_manager.blocked = false
	button.queue_free()

func match_limit_check():
	if matches >= match_limit:
		timer.start()

func _on_timer_timeout():
	timer.stop()
	update_collection()
	get_tree().change_scene_to_file(STORE_MENU_SCENE_PATH)

func update_collection():
	for card in collected_cards:
		if card.type == "currency":
			Global.coin += 10
		
		elif card.value_on_card not in Global.collection:
			Global.collection.append(card.value_on_card)
	
	http.update_collection(Global.collection)
	http.update_currency()
