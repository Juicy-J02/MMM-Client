extends Control

const GAME_SELECT_SCENE_PATH = "res://Scenes/GameSelect.tscn"
const DECK_MENU_SCENE_PATH = "res://Scenes/DeckMenu.tscn"
const STORE_MENU_SCENE_PATH = "res://Scenes/StoreMenu.tscn"
const LOGIN_SCENE_PATH = "res://Scenes/Login.tscn"

@onready var user_label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var coin_label = $HBoxContainer/MarginContainer3/VBoxContainer3/HBoxContainer/CoinLabel

func _ready():
	http.logout_sig.connect(_on_logout)
	user_label.text = Global.current_user
	coin_label.text = str(Global.coin)

func _on_start_pressed():
	var game_select_scene = preload(GAME_SELECT_SCENE_PATH)
	var new_game_select = game_select_scene.instantiate()
	self.add_child(new_game_select)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_deck_button_pressed():
	get_tree().change_scene_to_file(DECK_MENU_SCENE_PATH)

func _on_shop_button_pressed():
	get_tree().change_scene_to_file(STORE_MENU_SCENE_PATH)

func _on_logout_button_pressed():
	http.logout()
	get_tree().change_scene_to_file(LOGIN_SCENE_PATH)

func _on_logout():
	get_tree().change_scene_to_file(LOGIN_SCENE_PATH)
