extends Control

const MAIN_MENU_SCENE_PATH = "res://Scenes/MainMenu.tscn"
const PACK_OPEN_SCENE_PATH = "res://Scenes/PackOpen.tscn"

func _on_back_button_pressed():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)


func _on_button_pressed():
	if Global.coin >= 50:
		get_tree().change_scene_to_file(PACK_OPEN_SCENE_PATH)
		Global.coin -= 50
		http.update_currency()
