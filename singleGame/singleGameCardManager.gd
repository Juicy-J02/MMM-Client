extends Node2D

var current_card
var clicked_cards = []

signal move_sig
signal unflip_sig

@onready var input_manager = $"../InputManager"
@onready var match_manger = $"../MatchManager"

func _ready():
	input_manager.flip_card_sig.connect(flip)
	match_manger.match_sig.connect(matching)
	match_manger.no_match_sig.connect(unflip)

func flip(card):
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardFlip")
	await animation.animation_finished
	
	if !clicked_cards.has(card):
		clicked_cards.append(card)
	if clicked_cards.size() > 1:
		Game.matching_blocked = true
		move_sig.emit(clicked_cards)

func unflip(card):
	await get_tree().create_timer(1).timeout
	Game.matching_blocked = false
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardUnflip")
	await animation.animation_finished
	unflip_sig.emit()

func matching(card):
	await get_tree().create_timer(1).timeout
	Game.matching_blocked = false
	var animation = card.get_node("AnimationPlayer")
	animation.play("match")
	await animation.animation_finished
	card.queue_free()
