extends Node2D

@onready var game = get_tree().current_scene

var matched_cards = []

func _ready():
	ws.flip_card_sig.connect(flip)
	ws.unflip_card_sig.connect(unflip)
	ws.match_card_sig.connect(matching)
	ws.poison_card_sig.connect(poison)
	ws.unpoison_card_sig.connect(unpoison)
	ws.slime_card_sig.connect(slime)
	ws.slimeflip_card_sig.connect(slimeflip)
	ws.unslime_card_sig.connect(unslime)
	ws.shock_card_sig.connect(shock)
	ws.move_shock_card_sig.connect(unshock)
	ws.unshock_card_sig.connect(unshock)
	ws.burn_card_sig.connect(burn)
	ws.extinguish_card_sig.connect(extinguish)
	ws.freeze_card_sig.connect(freeze)
	ws.thaw_card_sig.connect(thaw)
	ws.highlight_card_sig.connect(highlight)
	ws.reveal_card_sig.connect(reveal)
	ws.unreveal_card_sig.connect(unreveal)

func flip(card_id):
	var selected_card = get_card_data(card_id)
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	var animation_2 = card.get_node("AnimatedSprite2D")
	if selected_card.revealed:
		animation_2.hide()
		animation_2.stop()
	elif selected_card.burned.active:
		animation.play("burnFlip")
	elif selected_card.highlight:
		animation.play("unhighlightFlip")
	else:
		animation.play("cardFlip")
	await animation.animation_finished

func unflip(card_ids):
	var animations = []
	
	for card_id in card_ids:
		var selected_card = get_card_data(card_id)
		var card = game.card_nodes[card_id]
		var animation = card.get_node("AnimationPlayer")
		var animation_2 = card.get_node("AnimatedSprite2D")
		if selected_card.revealed:
			animation_2.show()
			animation_2.play("revealed")
		elif selected_card.burned.active:
			animation.play("burnUnflip")
		else:
			animation.play("cardUnflip")
		animations.append(animation)
	
	if animations.size() > 0:
		await animations[0].animation_finished

func matching(card_ids):
	var animations = []
	
	for card_id in card_ids:
		var card = game.card_nodes[card_id]
		var animation = card.get_node("AnimationPlayer")
		animation.play("match")
		animations.append(animation)
		
		var animation_2 = card.get_node("AnimatedSprite2D")
		animation_2.hide()
		animation_2.stop()
		
	if animations.size() > 0:
		await animations[0].animation_finished

func poison(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("poison")
	await animation.animation_finished

func unpoison(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("unpoison")
	await animation.animation_finished

func slime(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("slime")
	await animation.animation_finished

func slimeflip(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("slimeFlip")
	await animation.animation_finished

func unslime(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("unslime")
	await animation.animation_finished

func shock(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("shock")
	await animation.animation_finished
	
	var animation_2 = card.get_node("AnimatedSprite2D")
	animation_2.show()
	animation_2.play("shock")

func unshock(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("unshock")
	await animation.animation_finished
	
	var animation_2 = card.get_node("AnimatedSprite2D")
	animation_2.hide()
	animation_2.stop()

func burn(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("burn")
	await animation.animation_finished

func extinguish(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("extinguish")
	await animation.animation_finished
	card.show_back()

func freeze(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("freeze")
	await animation.animation_finished

func thaw(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("thaw")
	await animation.animation_finished
	card.show_back()

func highlight(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("highlight")
	await animation.animation_finished

func unhighlight(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	animation.play("unhighlight")
	await animation.animation_finished

func reveal(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	var animation_2 = card.get_node("AnimatedSprite2D")
	animation.play("cardFlip")
	animation_2.show()
	animation_2.play("revealed")

func unreveal(card_id):
	var card = game.card_nodes[card_id]
	var animation = card.get_node("AnimationPlayer")
	var animation_2 = card.get_node("AnimatedSprite2D")
	animation.play("cardUnflip")
	animation_2.hide()
	animation_2.stop()

func get_card_data(card_id):
	for card in Game.board:
		if card["id"] == card_id:
			return card
	return null
