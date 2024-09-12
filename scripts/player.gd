extends CharacterBody2D

var current_speed: float = 0.0
var target_speed: float = 0.0

func _ready():
	add_to_group("player")

func _physics_process(delta):
	#if Constants.current_state == Constants.GameState.GAME_OVER:
		#return
	
	handle_rotation(delta)
	handle_speed_input()
	apply_movement(delta)
	apply_friction(delta)
	
	move_and_slide()

func handle_rotation(delta):
	var rotation_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotate(Constants.player_rotation_speed * rotation_input * delta)

func handle_speed_input():
	var acceleration_input = Input.get_action_strength("ui_up")
	var deceleration_input = Input.get_action_strength("ui_down")
	
	if acceleration_input > 0:
		if Input.is_action_just_pressed("ui_up") and target_speed == Constants.player_half_speed:
			target_speed = Constants.player_max_speed
		elif Input.is_action_just_pressed("ui_up") and  target_speed < Constants.player_half_speed:
			target_speed = Constants.player_half_speed
	elif deceleration_input > 0:
		if Input.is_action_just_pressed("ui_down"):
			target_speed = max(target_speed - Constants.player_half_speed, 0)
		elif Input.is_action_just_pressed("ui_down") and target_speed > 0:
			target_speed = 0

func apply_movement(delta):
	if current_speed < target_speed:
		current_speed = min(current_speed + Constants.player_acceleration * delta, target_speed)
	elif current_speed > target_speed:
		current_speed = max(current_speed - Constants.player_deceleration * delta, target_speed)
	
	velocity = -transform.y * current_speed

func apply_friction(delta):
	if target_speed == 0 and current_speed > 0:
		current_speed = max(current_speed - Constants.player_friction * delta, 0)
		velocity = -transform.y * current_speed
