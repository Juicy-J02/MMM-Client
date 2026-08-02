extends Control

const MAIN_MENU_SCENE_PATH = "res://Scenes/MainMenu.tscn"

@onready var timer = $Timer
@onready var label = $Label

var login_complete
var deck_complete
var collection_complete
var currency_complete

func _ready():
	timer.start()
	http.deck_load_sig.connect(_on_deck_load)
	http.collection_load_sig.connect(_on_collection_load)
	http.currency_load_sig.connect(_on_currency_load)

	if Global.registering_user:
		register_user()
		return

	http.get_deck()
	http.get_collection()
	http.get_currency()

func _on_timer_timeout():
	timer.stop()
	
	if label.text == "Loading":
		label.text = "Loading."
	elif label.text == "Loading.":
		label.text = "Loading.."
	elif label.text == "Loading..":
		label.text = "Loading..."
	elif label.text == "Loading...":
		label.text = "Loading"
	
	timer.start()

func _on_deck_load():
	deck_complete = true
	enter_main_menu()

func _on_collection_load():
	collection_complete = true
	enter_main_menu()

func _on_currency_load():
	currency_complete = true
	enter_main_menu()

func register_user():
	Global.deck = ["Blue", "Red", "Green", "Skeleton", "LeDuck", "ExtraLimbs", "Mirror", "BottleOPoison", "Drill"]
	Global.collection = ["Blue", "Red", "Green", "Skeleton", "LeDuck", "ExtraLimbs", "Mirror", "BottleOPoison", "Drill"]
	Global.coin = 0
	
	deck_complete = true
	collection_complete = true
	currency_complete  = true
	Global.registering_user = false
	enter_main_menu()

func enter_main_menu():
	if deck_complete and collection_complete and currency_complete:
		get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
