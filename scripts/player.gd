#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
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
