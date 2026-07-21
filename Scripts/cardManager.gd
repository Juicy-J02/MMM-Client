extends Node2D

var current_card
var clicked_cards = []
var blocked = false

signal move_sig
signal unflip_sig

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../InputManager".connect("left_click_card_sig", flip)
	$"../MatchManager".connect("no_match_sig", unflip)
	$"../MatchManager".connect("match_sig", matching)


func flip(card):
	if blocked:
		return
	
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardFlip")
	await animation.animation_finished
	
	if !clicked_cards.has(card):
		clicked_cards.append(card)
	if clicked_cards.size() > 1:
		#blocked = true
		move_sig.emit(clicked_cards)


func unflip(card):
	var animation = card.get_node("AnimationPlayer")
	animation.play("cardUnflip")
	await animation.animation_finished
	#blocked = false
	unflip_sig.emit()
	

func matching(card):
	var animation = card.get_node("AnimationPlayer")
	animation.play("match2")
	await animation.animation_finished
	#blocked = false
	card.queue_free()
