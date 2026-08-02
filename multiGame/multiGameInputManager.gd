extends Node2D

@onready var match_select = $"../HBoxContainer/MarginContainer3/RightPanel/MatchSelect"
@onready var column_select = $"../HBoxContainer/MarginContainer2/CenterPanel/ColumnSelect"
@onready var row_select = $"../HBoxContainer/MarginContainer2/CenterPanel/VBoxContainer"
@onready var board_select = $"../HBoxContainer/MarginContainer2/CenterPanel/BoardSelect"
@onready var reaction = $"../HBoxContainer/MarginContainer2/CenterPanel/Reaction"
@onready var reaction_select = $"../HBoxContainer/MarginContainer2/CenterPanel/Reaction/BoardSelect"
@onready var game = get_tree().current_scene

var card_being_dragged
var card_original_position
var card_original_scale

func _ready():
	board_select.hide()
	column_select.hide()
	row_select.hide()

func _process(_delta):
	if card_being_dragged:
		card_being_dragged.position = match_select.panel.get_local_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			handle_left_click(event.position)
		else:
			handle_left_unclick()

func handle_left_click(mouse_position):
	handle_match_select_click(mouse_position)
	handle_board_click()

func handle_left_unclick():
	if card_being_dragged:
		finish_drag()

func handle_match_select_click(mouse_position):
	if not match_select.is_point_inside_panel(mouse_position):
		return

	var card = get_card_under_mouse()
	if card != null and (card.type == "action" or card.type == "combo"):
		start_drag(card)

func handle_board_click():
	if Game.matching_blocked:
		return
	
	var card = get_card_under_mouse()

	if card == null:
		return

	if not game.card_nodes.has(card.card_id):
		return

	ws.send_json({
		"type": "select_card",
		"gameId": Game.current_game_id,
		"cardId": card.card_id,
		"turn": Game.turn
	})

func get_card_under_mouse():
	var space_state = get_world_2d().direct_space_state

	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true

	var result = space_state.intersect_point(parameters)

	if result.size() == 0:
		return null

	var node = result[0].collider.get_parent()

	if node is Card:
		return node

	return null

func start_drag(card):
	card_being_dragged = card
	card_original_position = card.position
	card_original_scale = card.scale
	card.scale = Vector2(1, 1)
	card.z_index = 5
	
	if Game.actions_blocked:
		return
	
	if card_being_dragged.action_type == "single_card_select":
		for card_data in Game.board:
			if !card_data["matched"]:
				var card_node = game.card_nodes[card_data["id"]]
				card_node.modulate = Color(0.4, 0.4, 0.4)
	if card_being_dragged.action_type == "board_select":
		board_select.show()
	if card_being_dragged.action_type == "column_select":
		column_select.show()
	if card_being_dragged.action_type == "row_select":
		row_select.show()
	if card_being_dragged.action_type == "match_select":
		for card_node in match_select.match_card_nodes:
			if card_node != card_being_dragged:
				card_node.modulate = Color(0.4, 0.4, 0.4)

func finish_drag():
	var drag_tween = create_tween()
	drag_tween.parallel().tween_property(card_being_dragged, "position", card_original_position, .1)
	drag_tween.parallel().tween_property(card_being_dragged, "scale", card_original_scale, .1)
	var action_card = card_being_dragged
	
	if action_card.action_type == "reaction" and reaction_select.get_global_rect().has_point(get_global_mouse_position()) and reaction.can_play_reaction(action_card.card_name):
		
		ws.send_json({
			"type": "reaction_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
			"turn": Game.turn,
		})
	
	if Game.actions_blocked:
		card_being_dragged.z_index = 0
		card_being_dragged = null
		return
	
	var target_card = get_card_under_mouse_excluding(action_card)
	var column = column_select.get_column_under_mouse()
	var row = row_select.get_row_under_mouse()
	
	if action_card.action_type == "single_card_select" and target_card != null and not target_card in match_select.match_card_nodes:
		
		ws.send_json({
			"type": "single_card_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
			"targetCardId": target_card.card_id
		})
	
	elif action_card.action_type == "board_select" and board_select.get_global_rect().has_point(get_global_mouse_position()):
		
		ws.send_json({
			"type": "board_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
		})
	
	elif action_card.action_type == "column_select" and column != -1:
		
		ws.send_json({
			"type": "column_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
			"targetColumn": column
		})
	
	elif action_card.action_type == "row_select" and row != -1:
		
		ws.send_json({
			"type": "row_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
			"targetRow": row
		})
	
	elif action_card.action_type == "match_select" and target_card != null and target_card in match_select.match_card_nodes:
		
		ws.send_json({
			"type": "match_select",
			"gameId": Game.current_game_id,
			"action": action_card.card_name,
			"targetCardId": target_card.card_id
		})
	
	for card_data in Game.board:
		if !card_data["matched"]:
			var card_node = game.card_nodes[card_data["id"]]
			card_node.modulate = Color(1, 1, 1)
	board_select.hide()
	column_select.hide()
	row_select.hide()
	for card_node in match_select.match_card_nodes:
		if card_node != card_being_dragged:
			card_node.modulate = Color(1, 1, 1)
	
	card_being_dragged.z_index = 0
	card_being_dragged = null

func get_card_under_mouse_excluding(excluded_card):
	var space_state = get_world_2d().direct_space_state

	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true

	var results = space_state.intersect_point(parameters, 10)

	for result in results:
		var node = result.collider.get_parent()

		if node is Card and node != excluded_card:
			return node

	return null
