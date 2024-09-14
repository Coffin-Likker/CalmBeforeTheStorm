extends Node

enum GameState { MENU, PLAYING, GAME_OVER }

# Game variables
var game_score: int = 0
var player_in_safezone: bool = false
var current_state: GameState = GameState.PLAYING

# Timer variables
var time_left: float = 50.0
var timer_running: bool = false

# Level generation variables
var map_size: Vector2 = Vector2(1153, 646)
var min_distance_between_objects: float = 100.0
var total_fish_on_screen: int = 7  # Adjust this number as needed
var special_fish_spawn_chance: float = 0.2  # 1/5 chance
var num_safezones: int = 3
const BORDER_BUFFER = 50  # Buffer zone from map edges
const CENTER_SAFE_RADIUS = 50  # Radius of safe zone in the center
const NUM_MINES = 5  # Adjust this number as needed

# Player movement variables
var player_max_speed: float = 200.0
var player_half_speed: float = 100.0
var player_acceleration: float = 90.0
var player_deceleration: float = 60.0
var player_rotation_speed: float = 1.5
var player_friction: float = 20.0
var player_speed_levels: int = 2

# Node references 
var score_label: RichTextLabel
var timer_label: RichTextLabel
var level_generator: Node
var fish_scene= load("res://scenes/fish.tscn")
var special_fish_scene= load("res://scenes/special_fish.tscn")
var safezone_scene = load("res://scenes/safezone.tscn")
var mine_scene = load("res://scenes/mine.tscn")

# Game over conditions 
var required_score: int = 20

func reset_game():
	game_score = 0
	player_in_safezone = false
	current_state = GameState.PLAYING
	time_left = 10.0
	timer_running = false

func update_score_display():
	if score_label:
		score_label.text = "Score: " + str(game_score) + "/25"

func update_time_display():
	if timer_label:
		timer_label.text = str(abs(ceil(time_left)))
