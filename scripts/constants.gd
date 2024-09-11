extends Node

enum GameState { MENU, PLAYING, GAME_OVER }

# Game variables
var game_score: int = 0
var temp_score: int = 0
var player_in_safezone: bool = false
var current_state: GameState = GameState.PLAYING

# Timer variables
var time_left: float = 10.0
var timer_running: bool = false

# Level generation variables
var map_size: Vector2 = Vector2(1153, 646)
var min_distance_between_objects: float = 30.0
var num_fish: int = 10
var num_safezones: int = 4

# Node references 
var score_label: RichTextLabel
var timer_label: RichTextLabel
var level_generator: Node

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
