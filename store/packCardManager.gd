extends Node2D

signal flip_sig
signal unflip_sig
signal match_sig

@onready var input_manager = $"../InputManager"
@onready var match_manager = $"../MatchManager"

func _ready():
	input_manager.flip_card_sig.connect(flip)
	match_manager.match_sig.connect(matching)

func flip(card):
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardFlip")
	await animation.animation_finished
	flip_sig.emit(card)

func unflip(card):
	await get_tree().create_timer(1).timeout
	Game.matching_blocked = false
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardUnflip")
	await animation.animation_finished
	unflip_sig.emit()

func matching(cards):
	var animations = []
	
	await get_tree().create_timer(.5).timeout
	Game.matching_blocked = false
	
	for card in cards:
		var animation = card.get_node("AnimationPlayer")
		animation.play("match")
		animations.append(animation)
	
	if animations.size() > 0:
		await animations[0].animation_finished
	
	match_sig.emit()
