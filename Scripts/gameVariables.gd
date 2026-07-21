extends Node

var current_game_id = -1
var board = []
var combo_characters = []

var actions = []

var player1_username = ""
var player2_username = ""

var player1_deck = []
var player2_deck = []

var player1_matches = []
var player2_matches = []

var player1_actions = []
var player2_actions = []

var player1_combo = []
var player2_combo = []

var current_turn = 0
var turn = 0

var player1_score = 0
var player2_score = 0

var can_start_game = false

var matching_blocked = false
var actions_blocked = false
var reaction_blocked = false
