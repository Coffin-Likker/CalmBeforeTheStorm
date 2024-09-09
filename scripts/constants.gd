extends Node

enum GameState { MENU, PLAYING, GAME_OVER }

@onready var score_label = $"../HUD/ScoreLabel"
@onready var timer_label = $"../HUD/TimeLabel"
var game_score = 0
var temp_score = 0
var player_in_safezone = false
var current_state = GameState.PLAYING

var time_left = 10.0
var timer_running = false

func reset_game():
	game_score = 0
	temp_score = 0
	player_in_safezone = false
	current_state = GameState.PLAYING
	time_left = 10.0
	timer_running = false

func update_score_display():
	if score_label:
		score_label.text = "Score: " + str(temp_score)

func update_time_display():
	if timer_label:
		timer_label.text = str(abs(ceil(time_left)))
