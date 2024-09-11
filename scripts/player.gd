extends CharacterBody2D

var speed = 200
var rotation_speed = 1.5

func _ready():
	add_to_group("player")

func _physics_process(delta):
	if Constants.current_state == Constants.GameState.GAME_OVER:
		return
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = - Input.get_action_strength("ui_up")
	
	if input_vector.x != 0:
		rotate(rotation_speed * input_vector.x * delta)
	
	if input_vector.y != 0:
		velocity = -transform.y * speed * input_vector.y
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
