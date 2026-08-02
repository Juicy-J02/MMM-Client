extends Control

@onready var player_1_name_label = $Player1Name
@onready var player_2_name_label = $Player2Name

@onready var player_1_score_label = $Player1Score
@onready var player_2_score_label = $Player2Score

# Called when the node enters the scene tree for the first time.
func _ready():
	ws.score_update_sig.connect(refresh_scores)
	player_1_name_label.text = Game.player1_username
	player_2_name_label.text = Game.player2_username

func refresh_scores():
	player_1_score_label.text = str(int(Game.player1_score))
	player_2_score_label.text = str(int(Game.player2_score))
