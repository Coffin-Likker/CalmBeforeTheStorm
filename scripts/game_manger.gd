extends Node

func _ready():
	for fish in get_tree().get_nodes_in_group("fish"):
		fish.connect("fish_entered", Callable(self, "_on_fish_entered"))
	
	for safezone in get_tree().get_nodes_in_group("safezone"):
		safezone.connect("safezone_entered", Callable(self, "_on_safezone_entered"))
		safezone.connect("safezone_exited", Callable(self, "_on_safezone_exited"))
	
	Constants.score_label = $"../HUD/ScoreLabel"
	Constants.timer_label = $"../HUD/TimeLabel"

	start_timer()
	print("Timer started")
	

func start_timer():
	Constants.time_left = 10.0
	Constants.timer_running = true

func _process(delta):
	if Constants.timer_running:
		Constants.time_left -= delta
		Constants.update_time_display()
		
		if Constants.time_left <= 0:
			Constants.timer_running = false
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
		Constants.current_state = Constants.GameState.GAME_OVER
		print("You died!")
	else:
		print("Player is safe")


func reset_game():
	Constants.reset_game()
	start_timer()
