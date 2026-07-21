extends Control

const REGISTER_SCENE_PATH = "res://Scenes/Register.tscn"
const LOADING_SCENE_PATH = "res://Scenes/Loading.tscn"

@onready var user_name = $VBoxContainer2/Username
@onready var password = $VBoxContainer2/Password
@onready var error_label = $ErrorLabel
@onready var timer = $Timer

func _ready():
	http.login_sig.connect(_on_login)
	http.error_sig.connect(_on_error)

func _on_login_button_pressed():
	if user_name.text.is_empty() or password.text.is_empty():
		return
	
	http.login(user_name.text, password.text)

func _on_login():
	get_tree().change_scene_to_file(LOADING_SCENE_PATH)

func _on_error(msg):
	error_label.text = msg
	timer.start()

func _on_timer_timeout():
	error_label.text = ""
	timer.stop()

func _on_register_button_pressed():
	get_tree().change_scene_to_file(REGISTER_SCENE_PATH)

func _on_exit_button_pressed():
	get_tree().quit()
