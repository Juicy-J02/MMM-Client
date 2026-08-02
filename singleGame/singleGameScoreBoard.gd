extends Control

@onready var player_1_score_label = $Player1Score

var player_1_score = 0

func _ready():
	$"../../MatchManager".connect("update_score", increase_score)

func increase_score(player, value):
	if player == 1:
		player_1_score += value
		player_1_score_label.text = str(player_1_score)
