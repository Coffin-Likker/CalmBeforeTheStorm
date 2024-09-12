extends Node

@onready var level_generator = $LevelGenerator
@onready var death_cloud = $'../DeathCloud'

func _ready():
	Constants.score_label = $"../HUD/ScoreLabel"
	Constants.timer_label = $"../HUD/TimeLabel"
	Constants.level_generator = level_generator
	start_game()

func start_game():
	level_generator.generate_level()

func _on_level_generated():
	connect_objects()
	start_timer()
	print("Level generated and timer started")

func connect_objects():
	for fish in get_tree().get_nodes_in_group("fish"):
		if not fish.is_connected("fish_entered", Callable(self, "_on_fish_entered")):
			fish.connect("fish_entered", Callable(self, "_on_fish_entered"))
	
	for safezone in get_tree().get_nodes_in_group("safezone"):
		if not safezone.is_connected("safezone_entered", Callable(self, "_on_safezone_entered")):
			safezone.connect("safezone_entered", Callable(self, "_on_safezone_entered"))
		if not safezone.is_connected("safezone_exited", Callable(self, "_on_safezone_exited")):
			safezone.connect("safezone_exited", Callable(self, "_on_safezone_exited"))

func start_timer():
	Constants.timer_running = true

func _process(delta):
	if Constants.timer_running:
		Constants.time_left -= delta
		Constants.update_time_display()
		
		if Constants.time_left <= 0:
			_on_timer_timeout()

func _on_safezone_entered():
	Constants.player_in_safezone = true
	Constants.game_score = Constants.temp_score
	Constants.update_score_display()
	print("Safe zone entered - Game Score: ", Constants.game_score)

func _on_safezone_exited():
	Constants.player_in_safezone = false
	print("Safe zone exited")

func _on_fish_entered():
	Constants.temp_score += 1
	Constants.update_score_display()
	print("Fish collected - Temporary Score: ", Constants.temp_score)

func _on_timer_timeout():
	print("Timer timeout")
	if not Constants.player_in_safezone and Constants.current_state != Constants.GameState.GAME_OVER:
		#Constants.current_state = Constants.GameState.GAME_OVER
		death_cloud.start_cloud_movement()
		Constants.timer_running = false
		print("You died!")
	else:
		Constants.time_left = 10.0
		print("Player is safe")

func reset_game():
	Constants.reset_game()
	start_game()
