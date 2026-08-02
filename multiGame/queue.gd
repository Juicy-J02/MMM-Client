extends Control

const GAME_SCENE_PATH = "res://Scenes/MultiGame.tscn"
const MAIN_MENU_SCENE_PATH = "res://Scenes/MainMenu.tscn"

func _ready():
	ws.start_game_sig.connect(_start_game)
	ws.sync_game_sig.connect(_start_game)
	http.matchmake_sig.connect(_matchmake)
	http.matchmake()

func _start_game():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_back_button_pressed():
	if Game.current_game_id != null:
		http.leave_game(Game.current_game_id)
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)

func _matchmake():
	ws.send_json({
		"type": "join_game",
		"gameId": Game.current_game_id,
	})

	if Game.can_start_game:
		create_board_data(Game.player1_deck + Game.player2_deck)
		create_combo_data(Game.player1_combo, Game.player2_combo)

		ws.send_json({
			"type": "start_game",
			"gameId": Game.current_game_id,
			"player1_name": Game.player1_username,
			"player2_name": Game.player2_username,
			"player1_deck": Game.player1_deck,
			"player2_deck": Game.player2_deck,
			"player1_combo": Game.player1_combo,
			"player2_combo": Game.player2_combo,
			"board": Game.board,
			"combo_characters": Game.combo_characters
		})

func create_board_data(board_deck):
	Game.board.clear()

	for i in board_deck:
		Game.board.append({
			"id": Game.board.size(),
			"board_value": i,
			"art": i,
			"type": CardDatabase.CARDS[i].type,
			"card_type": CardDatabase.CARDS[i].card_type,
			"action_type": CardDatabase.CARDS[i].action_type,
			"selected": false,
			"matched": false,
			"burned": {"active": false, "timer": 0},
			"frozen": {"active": false, "timer": 0},
			"poisoned": [false, 0],
			"slimed": [false, 0],
			"shocked": [false, 0],
			"charge": [false, 0],
			"highlight": false,
			"revealed": false,
			"protected": false,
		})

		Game.board.append({
			"id": Game.board.size(),
			"board_value": i,
			"art": i,
			"type": CardDatabase.CARDS[i].type,
			"card_type": CardDatabase.CARDS[i].card_type,
			"action_type": CardDatabase.CARDS[i].action_type,
			"selected": false,
			"matched": false,
			"burned": {"active": false, "timer": 0},
			"frozen": {"active": false, "timer": 0},
			"poisoned": [false, 0],
			"slimed": [false, 0],
			"shocked": [false, 0],
			"charge": [false, 0],
			"highlight": false,
			"revealed": false,
			"protected": false,
		})

	Game.board.shuffle()
	
	var grid_size = get_grid_size(Game.board.size())
	var cols = grid_size.x

	for index in range(Game.board.size()):
		var col = index % cols
		var row = int(index / cols)

		Game.board[index]["grid_pos"] = {
			"x": col,
			"y": row
		}

func create_combo_data(player1_combo, player2_combo):
	Game.combo_characters.clear()

	if player1_combo:
		Game.combo_characters.append({
			"id": 998,
			"art": player1_combo,
			"type": ComboCardDatabase.CARDS[player1_combo].type,
			"card_type": ComboCardDatabase.CARDS[player1_combo].card_type,
			"action_type": ComboCardDatabase.CARDS[player1_combo].action_type,
			"combo_cards": ComboCardDatabase.CARDS[player1_combo].combo_cards,
			"card1_matched": [false, 0],
			"card2_matched": [false, 0],
			"added_to_hand": false,
		})

	if player2_combo:
		Game.combo_characters.append({
			"id": 999,
			"art": player2_combo,
			"type": ComboCardDatabase.CARDS[player2_combo].type,
			"card_type": ComboCardDatabase.CARDS[player2_combo].card_type,
			"action_type": ComboCardDatabase.CARDS[player2_combo].action_type,
			"combo_cards": ComboCardDatabase.CARDS[player2_combo].combo_cards,
			"card1_matched": [false, 0],
			"card2_matched": [false, 0],
			"added_to_hand": false,
		})

func get_grid_size(card_count: int) -> Vector2i:
	var column = int(ceil(sqrt(card_count)))
	var row = int(ceil(float(card_count) / float(column)))
	return Vector2i(column, row)
