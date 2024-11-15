extends Node

@onready var level_generator = $'../LevelGenerator'
@onready var death_cloud = $'../DeathCloud'
@onready var warning_panel = $'../HUD/WarningPanel'
@onready var HUD = $'../HUD'
@onready var menu_manager = $'../MenuManager'
@onready var gg_menu = $'../MenuManager/GameOverPanel'
@onready var player = $'../Player'
@onready var music = $'../ThemeSong'
@onready var fish_noise = $'../PickUp'

var direction

func _ready():
	Constants.score_label = $"../HUD/ScoreLabel"
	Constants.timer_label = $"../HUD/TimeLabel"
	level_generator.connect("level_generated", Callable(self, "_on_level_generated"))
	level_generator.connect("fish_spawned", Callable(self, "_on_fish_spawned"))
	level_generator.connect("mine_spawned", Callable(self, "_on_mine_spawned"))
	death_cloud.connect("cloud_hit_player", Callable(self, "_on_cloud_hit_player"))


func start_game():
	level_generator.generate_level()
	music.play(1)
	HUD.show()
	Constants.update_score_display()
	pick_direction()


func _on_level_generated():
	connect_objects()
	start_timer()
	print("Level generated and timer started")

func connect_objects():
	for fish in get_tree().get_nodes_in_group("fish") + get_tree().get_nodes_in_group("special_fish"):
		if not fish.is_connected("fish_entered", Callable(self, "_on_fish_entered")):
			fish.connect("fish_entered", Callable(self, "_on_fish_entered"))

	for safezone in get_tree().get_nodes_in_group("safezone"):
		if not safezone.is_connected("safezone_entered", Callable(self, "_on_safezone_entered")):
			safezone.connect("safezone_entered", Callable(self, "_on_safezone_entered"))

	for mine in get_tree().get_nodes_in_group("mine"):
		if not mine.is_connected("mine_hit", Callable(self, "_on_mine_hit")):
			mine.connect("mine_hit", Callable(self, "_on_mine_hit"))

func _on_mine_hit():
	_game_over("You Lost...", "You hit a mine.")

func _on_fish_spawned(fish_instance):
	if not fish_instance.is_connected("fish_entered", Callable(self, "_on_fish_entered")):
		fish_instance.connect("fish_entered", Callable(self, "_on_fish_entered"))
		
# Add this function to connect mine signals
func _on_mine_spawned(mine_instance):
	if not mine_instance.is_connected("mine_hit", Callable(self, "_on_mine_hit")):
		mine_instance.connect("mine_hit", Callable(self, "_on_mine_hit"))

func start_timer():
	Constants.timer_running = true

func _process(delta):
	if Constants.timer_running:
		Constants.time_left -= delta
		Constants.update_time_display()
		if round(Constants.time_left) == 5:
			warning_panel.trigger_panel(direction)
		if Constants.time_left <= 0:
			_on_timer_timeout()

func _on_safezone_entered():
	if Constants.game_score >= Constants.required_score:
		Constants.player_in_safezone = true
		Constants.update_score_display()
		_game_over("You Won!", "Congratulations!")
	else:
		_game_over("You Lost...", "You didn't catch 
		enough fish.")	

func _on_fish_entered(fish):
	fish_noise.play(0)
	if fish.is_in_group("special_fish"):
		Constants.game_score += 2
		print("Special fish collected - Score +3")
	else:
		Constants.game_score += 1
		print("Regular fish collected - Score +1")
		
	Constants.update_score_display()
	print("Total Score: ", Constants.game_score)
	
	fish.queue_free()
	call_deferred("spawn_new_fish")
	
func spawn_new_fish():
	level_generator.spawn_random_fish()

func _on_timer_timeout():
	print("Timer timeout")
	death_cloud.start_cloud_movement(direction)
	Constants.timer_running = false

func _on_cloud_hit_player():
	_game_over("You Lost...", "The storm caught 
	you.")

func _game_over(outcome, reason):
	if Constants.current_state != Constants.GameState.GAME_OVER:
		Constants.current_state = Constants.GameState.GAME_OVER
		Constants.timer_running = false
		menu_manager.outro_panel.show()
		menu_manager.outro_outcome_label.text = outcome
		menu_manager.outro_outro_label.text = reason
		menu_manager.outro_final_label.text = "Final Score: " + str(Constants.game_score) + "/" + str(Constants.required_score)
	#if  Constants.game_score >= Constants.required_score and (reason != "Hit by cloud!"):
		#print("Game Over: " + "you Won")
	#else:
		#print("Game Over: " + reason)


func reset_game():
	Constants.reset_game()
	death_cloud.set_position(Vector2(-1316, -53))
	player.current_speed = 0
	player.target_speed = 0
	warning_panel.is_flashing = false
	start_game()

func pick_direction():
	direction = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	print('direction: ', direction)
