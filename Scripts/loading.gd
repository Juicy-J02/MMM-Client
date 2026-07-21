extends Control

const MAIN_MENU_SCENE_PATH = "res://Scenes/MainMenu.tscn"

@onready var timer = $Timer
@onready var label = $Label

var login_complete
var deck_complete

func _ready():
	http.deck_load_sig.connect(_on_deck_load)
	http.get_deck()
	timer.start()

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
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
