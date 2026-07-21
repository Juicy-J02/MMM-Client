extends Node2D

signal left_click_card_sig

var screen_size
var card_being_dragged
var card_original_position
var card_original_scale

@onready var deck = $"../HBoxContainer/MarginContainer2/VBoxContainer/DeckCards"
@onready var collection = $"../HBoxContainer/MarginContainer2/VBoxContainer/ScrollContainer"

func _process(_delta):
	if card_being_dragged:
		card_being_dragged.position = deck.get_local_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			handle_left_click()
		else:
			handle_left_unclick()

func handle_left_click():
	var card = get_card_under_mouse()
	if card in deck.deck:
		start_drag(card)
	if card in collection.collection:
		left_click_card_sig.emit(card)

func handle_left_unclick():
	if card_being_dragged:
		finish_drag()

func start_drag(card):
	card_being_dragged = card
	card_original_position = card.position
	card_original_scale = card.scale
	card.scale = Vector2(1, 1)
	card.z_index = 5

func finish_drag():
	var drag_tween = create_tween()
	drag_tween.parallel().tween_property(card_being_dragged, "position", card_original_position, .1)
	drag_tween.parallel().tween_property(card_being_dragged, "scale", card_original_scale, .1)
	card_being_dragged.z_index = 0
	card_being_dragged = null

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
