extends VBoxContainer

@onready var match_select = $MatchSelect
#@onready var action_select = $ActionSelect

func _ready():
	ws.match_update_sig.connect(draw_matches)

func _on_exit_button_pressed():
	http.leave_game(Game.current_game_id)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_match_button_pressed():
	match_select.show()
	draw_matches()

func draw_matches():
	if Game.turn == 1:
		match_select.draw_matches(Game.player1_matches)
	else:
		match_select.draw_matches(Game.player2_matches)
