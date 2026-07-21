extends Control

const GAME_SCENE_PATH = "res://Scenes/SingleGame.tscn"
const QUEUE_SCENE_PATH = "res://Scenes/Queue.tscn"

@onready var panel = $Panel

func _on_single_pressed():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_multi_pressed():
	get_tree().change_scene_to_file(QUEUE_SCENE_PATH)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not panel.get_global_rect().has_point(event.position):
			queue_free()
