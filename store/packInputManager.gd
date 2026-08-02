extends Node2D

@onready var pack = $".."

signal flip_card_sig

var blocked

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and pack.matches < pack.match_limit and !blocked:
			handle_left_click()

func handle_left_click():
	var card = get_card_under_mouse()

	if card == null:
		return

	flip_card_sig.emit(card)

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
