extends Control

@onready var game_manager = $'../GameManager'
@onready var intro_panel = $'IntroUIPanel'
@onready var outro_panel = $'GameOverPanel'
@onready var outro_outcome_label =$'GameOverPanel/OutcomeLabel'
@onready var outro_outro_label = $'GameOverPanel/OutroLabel'
@onready var outro_final_label = $'GameOverPanel/FinalScoreLabel'

# Called when the node enters the scene tree for the first time.
func _ready():
	intro_panel.show()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	game_manager.start_game()
	intro_panel.hide()
	pass # Replace with function body.


func _on_restart_button_pressed():
	game_manager.reset_game()
	outro_panel.hide()
	pass # Replace with function body.
