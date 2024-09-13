extends Node

@onready var level_generator = $'../LevelGenerator'
@onready var death_cloud = $'../DeathCloud'
var direction

func _ready():
	Constants.score_label = $"../HUD/ScoreLabel"
	Constants.timer_label = $"../HUD/TimeLabel"
	level_generator.connect("level_generated", Callable(self, "_on_level_generated"))
	death_cloud.connect("cloud_hit_player", Callable(self, "_on_cloud_hit_player"))
	start_game()
	pick_direction()

func start_game():
	level_generator.generate_level()

func _on_level_generated():
	connect_objects()
	start_timer()
	print("Level generated and timer started")

func connect_objects():
	print(get_tree())
	print(get_tree().get_nodes_in_group("fish"))
	for fish in get_tree().get_nodes_in_group("fish"):
		if not fish.is_connected("fish_entered", Callable(self, "_on_fish_entered")):
			fish.connect("fish_entered", Callable(self, "_on_fish_entered"))

	for special_fish in get_tree().get_nodes_in_group("special_fish"):
		if not special_fish.is_connected("special_fish_entered", Callable(self, "_on_special_fish_entered")):
			special_fish.connect("special_fish_entered", Callable(self, "_on_special_fish_entered"))

	for safezone in get_tree().get_nodes_in_group("safezone"):
		if not safezone.is_connected("safezone_entered", Callable(self, "_on_safezone_entered")):
			safezone.connect("safezone_entered", Callable(self, "_on_safezone_entered"))

func start_timer():
	Constants.timer_running = true

func _process(delta):
	if Constants.timer_running:
		Constants.time_left -= delta
		Constants.update_time_display()
		
		if Constants.time_left <= 0:
			_on_timer_timeout()

func _on_safezone_entered():
	if Constants.game_score >= Constants.required_score:
		Constants.player_in_safezone = true
		Constants.update_score_display()
		_game_over("Entered safezone with enough fish!")
	else:
		_game_over("Entered safezone without enough fish!")



func _on_fish_entered():
	Constants.game_score += 1
	Constants.update_score_display()
	print("Fish collected - Score: ", Constants.game_score)

func _on_special_fish_entered():
	Constants.game_score += 3
	Constants.update_score_display()
	print("Special Fish collected - Score: ", Constants.game_score)

func _on_timer_timeout():
	print("Timer timeout")
	death_cloud.start_cloud_movement(direction)
	Constants.timer_running = false

func _on_cloud_hit_player():
	_game_over("Hit by cloud!")

func _game_over(reason):
	Constants.current_state = Constants.GameState.GAME_OVER
	Constants.timer_running = false
	if  Constants.game_score >= Constants.required_score:
		print("Game Over: " + "you Won")
	else:
		print("Game Over: " + reason)


func reset_game():
	Constants.reset_game()
	start_game()

func pick_direction():
	direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	print('direction: ', direction)
