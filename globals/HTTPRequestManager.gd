extends Node

signal login_sig
signal register_sig
signal logout_sig
signal matchmake_sig
signal deck_load_sig
signal collection_load_sig
signal currency_load_sig
signal error_sig

var auth_token := ""
var pending_user_name := ""

var local = "http://127.0.0.1:3000"
var production = "https://mmm-server-l9tn.onrender.com"

var url = local

@onready var login_request = $LoginRequest
@onready var register_request = $RegisterRequest
@onready var logout_request = $LogoutRequest
@onready var get_deck_request = $GetDeckRequest
@onready var update_deck_request = $UpdateDeckRequest
@onready var matchmake_request = $MatchmakeRequest
@onready var leave_game_request = $LeaveGameRequest
@onready var get_collection_request = $GetCollectionRequest
@onready var update_collection_request = $UpdateCollectionRequest
@onready var get_currency_request = $GetCurrencyRequest
@onready var update_currency_request = $UpdateCurrencyRequest

func _ready():
	login_request.request_completed.connect(_on_login_completed)
	register_request.request_completed.connect(_on_register_completed)
	logout_request.request_completed.connect(_on_logout_completed)
	get_deck_request.request_completed.connect(_on_get_deck_completed)
	update_deck_request.request_completed.connect(_on_update_deck_completed)
	matchmake_request.request_completed.connect(_on_matchmake_completed)
	leave_game_request.request_completed.connect(_on_leave_game_completed)
	get_collection_request.request_completed.connect(_on_get_collection_completed)
	update_collection_request.request_completed.connect(_on_update_collection_completed)
	get_currency_request.request_completed.connect(_on_get_currency_completed)
	update_currency_request.request_completed.connect(_on_update_currency_completed)

func login(user_name: String, password: String) -> void:
	pending_user_name = user_name
	
	var headers = [
		"Content-Type: application/json"
	]

	var body = JSON.stringify({
		"userName": user_name,
		"password": password
	})

	var err = login_request.request(url + "/api/auth", headers, HTTPClient.METHOD_PUT, body)
	if err != OK:
		print("Failed to start request: ", err)

func register(user_name: String, password: String) -> void:
	pending_user_name = user_name

	var headers = [
		"Content-Type: application/json"
	]

	var body = JSON.stringify({
		"userName": user_name,
		"password": password
	})

	var err = register_request.request(url + "/api/auth", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		print("Failed to start request: ", err)

func logout() -> void:
	var headers = [
		"Authorization: " + Global.auth_token
	]

	var err = logout_request.request(url + "/api/auth", headers, HTTPClient.METHOD_DELETE)
	if err != OK:
		print("Failed to start request: ", err)

func get_deck() -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var err = get_deck_request.request(url + "/api/deck", headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("Failed to start request: ", err)

func update_deck(deck, combo_character) -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var body = JSON.stringify({
		"deck": deck,
		"combo_character": combo_character
	})
	
	var err = update_deck_request.request(url + "/api/deck", headers, HTTPClient.METHOD_PUT, body)
	if err != OK:
		print("Failed to start request: ", err)

func get_collection() -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var err = get_collection_request.request(url + "/api/collection", headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("Failed to start request: ", err)

func update_collection(collection) -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var body = JSON.stringify({
		"collection": collection
	})
	
	var err = update_collection_request.request(url + "/api/collection", headers, HTTPClient.METHOD_PUT, body)
	if err != OK:
		print("Failed to start request: ", err)

func get_currency() -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var err = get_currency_request.request(url + "/api/currency", headers, HTTPClient.METHOD_GET)
	if err != OK:
		print("Failed to start request: ", err)

func update_currency() -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var body = JSON.stringify({
		"coin": Global.coin,
	})
	
	var err = update_currency_request.request(url + "/api/currency", headers, HTTPClient.METHOD_PUT, body)
	if err != OK:
		print("Failed to start request: ", err)
	

func matchmake() -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]
	
	var err = matchmake_request.request(url + "/api/game/matchmake", headers, HTTPClient.METHOD_POST)
	if err != OK:
		print("Failed to start request: ", err)

func leave_game(game_id) -> void:
	var headers = [
		"Content-Type: application/json",
		"Authorization: " + Global.auth_token
	]

	var err = leave_game_request.request(url + "/api/game/" + str(int(game_id)) + "/leave", headers, HTTPClient.METHOD_PUT)
	if err != OK:
		print("Failed to start request: ", err)

func _on_login_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code not in [200, 201]:
		error_sig.emit(data["message"])
		return
	
	Global.auth_token = data["token"]
	Global.current_user = pending_user_name
	
	login_sig.emit()

func _on_register_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code not in [200, 201]:
		error_sig.emit(data["message"])
		return
	
	Global.auth_token = data["token"]
	Global.current_user = pending_user_name
	
	register_sig.emit()

func _on_logout_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var _data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Global.auth_token = ""
	Global.current_user = ""

func _on_get_deck_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Global.deck = data["deck"]
	Global.combo_character = data["combo_character"]
	
	deck_load_sig.emit()

func _on_update_deck_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var _data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return

func _on_get_collection_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Global.collection = data["collection"]
	
	collection_load_sig.emit()

func _on_update_collection_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var _data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return

func _on_get_currency_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Global.coin = int(data["coin"])
	
	currency_load_sig.emit()

func _on_update_currency_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var _data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return

func _on_matchmake_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Game.current_game_id = data["game_id"]
	Game.player1_username = data["player1_username"]
	Game.player2_username = data["player2_username"]
	Game.player1_deck = data["player1_deck"]
	Game.player2_deck = data["player2_deck"]
	Game.player1_combo = data["player1_combo"]
	Game.player2_combo = data["player2_combo"]
	Game.turn = data["turn"]
	Game.can_start_game = data["player_1"] != null and data["player_2"] != null
	
	matchmake_sig.emit()

func _on_leave_game_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var _data = parse_response(result, response_code, headers, body)
	
	if response_code == 401:
		logout_sig.emit()
		return
	
	if response_code != 200:
		return
	
	Game.current_game_id = null
	Game.player1_username = null
	Game.player2_username = null
	Game.player1_deck = null
	Game.player2_deck = null
	Game.player1_combo = null
	Game.player2_combo = null
	Game.turn = null
	Game.can_start_game = null

func parse_response(result, response_code, _headers, body):
	var text = body.get_string_from_utf8()
	var data = JSON.parse_string(text)

	print("HTTP result: ", result)
	print("HTTP code: ", response_code)
	print("Raw body: ", text)
	print("Parsed response: ", data)

	return data
