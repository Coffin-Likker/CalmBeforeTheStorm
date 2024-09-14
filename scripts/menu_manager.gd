extends Control

@onready var game_manager = $'../GameManager'
@onready var intro_panel = $'IntroUIPanel'

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
