extends Control

const LOGIN_SCENE_PATH = "res://Scenes/Login.tscn"
const LOADING_SCENE_PATH = "res://Scenes/Loading.tscn"

@onready var user_name = $VBoxContainer2/Username
@onready var password = $VBoxContainer2/Password
@onready var error_label = $ErrorLabel
@onready var timer = $Timer

func _ready():
	http.register_sig.connect(_on_register)
	http.error_sig.connect(_on_error)

func _on_register_button_pressed():
	if user_name.text.is_empty() or password.text.is_empty():
		return

	http.register(user_name.text, password.text)

func _on_register():
	Global.registering_user = true
	get_tree().change_scene_to_file(LOADING_SCENE_PATH)

func _on_error(msg):
	error_label.text = msg
	timer.start()

func _on_timer_timeout():
	error_label.text = ""
	timer.stop()

func _on_back_button_pressed():
	get_tree().change_scene_to_file(LOGIN_SCENE_PATH)

func _on_exit_button_pressed():
	get_tree().quit()
