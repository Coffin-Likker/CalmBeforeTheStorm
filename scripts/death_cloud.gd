extends Node2D

@export var cloud_speed = 100  # Adjust this value to change the cloud's speed
var move_direction = Vector2.ZERO
var is_moving = false
var screen_width = 0
var cloud_width = 0
var camera = Node2D

func _ready():
	# Hide the cloud initially
	visible = false
	

	camera = get_node("../Camera2D")
	if not camera:
		push_error("Camera2D not found. Make sure it's at the same level as the death cloud in the scene hierarchy.")
		return
	
	# Calculate the screen width based on the camera's zoom
	var viewport_size = get_viewport_rect().size
	screen_width = viewport_size.x / camera.zoom.x
	
	# Calculate the cloud width
	var used_rect = $Cloud_tilemap.get_used_rect()
	cloud_width = used_rect.size.x * $Cloud_tilemap.tile_set.tile_size.x
	
	# Connect to the timer timeout signal
	var game_manager = get_node("/root/Main/GameManager")
	game_manager.connect("on_timer_timeout", Callable(self, "start_cloud_movement"))

func _process(delta):
	if is_moving:
		position += move_direction * cloud_speed * delta
		print(position.x)
		# Check if the cloud has covered the entire screen
		if cloud_covers_screen():
			print('STOP')
			is_moving = false

func start_cloud_movement():
	visible = true
	is_moving = true
	
	# Randomly choose left or right side
	var start_from_left = randf() > 0.5
	
	if start_from_left:
		position.x = camera.get_screen_center_position().x - (screen_width / 2) - cloud_width
		move_direction = Vector2.RIGHT
	else:
		position.x = camera.get_screen_center_position().x + (screen_width / 2)
		move_direction = Vector2.LEFT
	
	# Set Y position to align the cloud vertically
	position.y = -10

func cloud_covers_screen() -> bool:
	var screen_center_x = camera.get_screen_center_position().x
	if move_direction == Vector2.RIGHT:
		return position.x + cloud_width >= screen_center_x + (screen_width / 2) +10
	else:
		return position.x <= screen_center_x - (screen_width / 2) -10
