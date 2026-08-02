extends Node

var socket := WebSocketPeer.new()
var connected := false
var timer_started

signal sync_game_sig
signal start_game_sig
signal flip_card_sig
signal unflip_card_sig
signal match_card_sig
signal poison_card_sig
signal unpoison_card_sig
signal burn_card_sig
signal extinguish_card_sig
signal freeze_card_sig
signal thaw_card_sig
signal highlight_card_sig
signal slime_card_sig
signal slimeflip_card_sig
signal unslime_card_sig
signal shock_card_sig
signal move_shock_card_sig
signal unshock_card_sig
signal reveal_card_sig
signal unreveal_card_sig
signal tap_off_sig
signal multi_select_sig
signal score_update_sig
signal match_update_sig
signal combo_update_sig
signal reaction_sig
signal reaction_success_sig
signal end_turn_sig

var local = "ws://127.0.0.1:3000/ws"
var production = "wss://mmm-server-l9tn.onrender.com/ws"

var url = local

@onready var timer = $Timer

func _ready():
	var err = socket.connect_to_url(url)
	if err != OK:
		pass
		# print("Failed to start WebSocket connection: ", err)

func _process(_delta):
	socket.poll()

	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN and not connected:
		connected = true

	elif state == WebSocketPeer.STATE_CLOSING:
		pass
		# print("Socket closing")

	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			# print("Socket closed")
			connected = false
			# print("Close code: ", socket.get_close_code())
			# print("Close reason: ", socket.get_close_reason())

	if !connected and !timer_started:
		timer.start()
		timer_started = true

	while socket.get_available_packet_count() > 0:
		var packet = socket.get_packet()
		var message = packet.get_string_from_utf8()

		if socket.was_string_packet():
			handle_message(message)
		else:
			pass
			# print("Received binary packet")

func send_json(data: Dictionary) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var json_text = JSON.stringify(data)
		socket.send_text(json_text)

func handle_message(message: String) -> void:
	var data = JSON.parse_string(message)
	if data == null:
		print("Invalid JSON from server: ", message)
		return

	data = normalize_numbers(data)

	match data.get("type", ""):
		"sync_game":
			Game.board = data["board"]
			Game.player1_username = data["player1_name"]
			Game.player2_username = data["player2_name"]
			Game.player1_deck = data["player1_deck"]
			Game.player2_deck = data["player2_deck"]
			Game.player1_matches = data["player1_matches"]
			Game.player2_matches = data["player2_matches"]
			Game.player1_actions = data["player1_actions"]
			Game.player2_actions = data["player2_actions"]
			Game.player1_combo = data["player1_combo"]
			Game.player2_combo = data["player2_combo"]
			Game.player1_score = data["score_1"]
			Game.player2_score = data["score_2"]
			Game.current_turn = data["current_turn"]
			Game.combo_characters = data["combo_characters"]
			sync_game_sig.emit()
		
		"start_game":
			Game.board = data["board"]
			Game.player1_username = data["player1_name"]
			Game.player2_username = data["player2_name"]
			Game.player1_deck = data["player1_deck"]
			Game.player2_deck = data["player2_deck"]
			Game.player1_matches = data["player1_matches"]
			Game.player2_matches = data["player2_matches"]
			Game.player1_actions = data["player1_actions"]
			Game.player2_actions = data["player2_actions"]
			Game.player1_combo = data["player1_combo"]
			Game.player2_combo = data["player2_combo"]
			Game.player1_score = data["score_1"]
			Game.player2_score = data["score_2"]
			Game.current_turn = data["current_turn"]
			Game.combo_characters = data["combo_characters"]
			start_game_sig.emit()
			
			if Game.turn != Game.current_turn:
				Game.matching_blocked = true
				Game.actions_blocked = true
			else:
				Game.matching_blocked = false
				Game.actions_blocked = false
			Game.reaction_blocked = true
		
		"flip_card":
			Game.board = data["board"]
			flip_card_sig.emit(data["cardId"])
		
		"unflip_cards":
			Game.board = data["board"]
			unflip_card_sig.emit(data["cardIds"])
		
		"match_cards":
			Game.board = data["board"]
			Game.combo_characters = data["combo_characters"]
			match_card_sig.emit(data["cardIds"])
			combo_update_sig.emit()
		
		"end_turn":
			Game.board = data["board"]
			Game.current_turn = data["current_turn"]
			Game.player1_matches = data["player1_matches"]
			Game.player2_matches = data["player2_matches"]
			Game.player1_score = data["score_1"]
			Game.player2_score = data["score_2"]
			match_update_sig.emit()
			score_update_sig.emit()
			end_turn_sig.emit()
			
			if Game.turn != Game.current_turn:
				Game.matching_blocked = true
				Game.actions_blocked = true
			else:
				Game.matching_blocked = false
				Game.actions_blocked = false
		
		"update_match":
			Game.board = data["board"]
			Game.player1_matches = data["player1_matches"]
			Game.player2_matches = data["player2_matches"]
			Game.player1_score = data["score_1"]
			Game.player2_score = data["score_2"]
			match_update_sig.emit()
			score_update_sig.emit()
		
		"single_card_select":
			Game.board = data["board"]
			var selected_card
			for card in Game.board:
				if card["id"] == data["cardId"]:
					selected_card = card
			if data["action"] == "Poison":
				if selected_card.poisoned[1] == Game.turn:
					poison_card_sig.emit(data["cardId"])
			if data["action"] == "Unpoison":
				unpoison_card_sig.emit(data["cardId"])
			if data["action"] == "Slime":
				if selected_card.slimed[1] == Game.turn:
					slime_card_sig.emit(data["cardId"])
			if data["action"] == "SlimeFlip":
				slimeflip_card_sig.emit(data["cardId"])
			if data["action"] == "Unslime":
				unslime_card_sig.emit(data["cardId"])
			if data["action"] == "Shock":
				if selected_card.shocked[1] == Game.turn:
					shock_card_sig.emit(data["cardId"])
			if data["action"] == "Move Shock":
				if selected_card.shocked[1] == Game.turn:
					move_shock_card_sig.emit(data["cardId"])
			if data["action"] == "Unshock":
				unshock_card_sig.emit(data["cardId"])
			if data["action"] == "Burn":
				burn_card_sig.emit(data["cardId"])
			if data["action"] == "Extinguish":
				extinguish_card_sig.emit(data["cardId"])
			if data["action"] == "Freeze":
				freeze_card_sig.emit(data["cardId"])
			if data["action"] == "Thaw":
				thaw_card_sig.emit(data["cardId"])
			if data["action"] == "Reveal":
				reveal_card_sig.emit(data["cardId"])
			if data["action"] == "Unreveal":
				unreveal_card_sig.emit(data["cardId"])
			if data["action"] == "Highlight":
				highlight_card_sig.emit(data["cardId"])
		
		"tap_off":
			Game.board = data["board"]
			tap_off_sig.emit(data["turn"], data["time"], data["tap_trigger"], data["action"])
		
		"reaction":
			Game.board = data["board"]
			reaction_sig.emit(data["turn"], data["reaction_type"])
		
		"reaction_success":
			Game.board = data["board"]
			reaction_success_sig.emit(data["reaction_type"])
		
		"multi_card_select":
			Game.board = data["board"]
			multi_select_sig.emit()

func normalize_numbers(value):
	if value is Dictionary:
		for key in value.keys():
			value[key] = normalize_numbers(value[key])
		return value

	if value is Array:
		for i in range(value.size()):
			value[i] = normalize_numbers(value[i])
		return value

	if value is float:
		if value == floor(value):
			return int(value)

	return value


func _on_timer_timeout():
	# print("connecting")
	_ready()
	timer.stop()
	timer_started = false
	
