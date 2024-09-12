extends Node2D

@export var cloud_speed = 100  # Adjust this value to change the cloud's speed
var move_direction = Vector2.ZERO
var is_moving = false
var viewport_width = 0
var cloud_width = 0

func _ready():
	# Hide the cloud initially
	visible = false
	
	# Get the viewport width
	viewport_width = get_viewport_rect().size.x
	
	# Calculate the cloud width
	var used_rect = $Cloud_tilemap.get_used_rect()
	cloud_width = used_rect.size.x * $Cloud_tilemap.tile_set.tile_size.x * 2
	
	# Connect to the timer timeout signal
	var game_manager = get_node("/root/Main/GameManager")
	game_manager.connect("on_timer_timeout", Callable(self, "start_cloud_movement"))

func _process(delta):
	if is_moving:
		position += move_direction * cloud_speed * delta
		
		# Check if the cloud has covered the entire screen
		if cloud_covers_screen():
			is_moving = false

func start_cloud_movement():
	visible = true
	is_moving = true
	
	# Randomly choose left or right side
	var start_from_left = randf() > 0.5
	
	if start_from_left:
		position.x = -cloud_width
		move_direction = Vector2.RIGHT
	else:
		position.x = viewport_width
		move_direction = Vector2.LEFT
	
	# Set Y position to align the cloud vertically
	position.y = 0

func cloud_covers_screen() -> bool:
	if move_direction == Vector2.RIGHT:
		return position.x + cloud_width >= viewport_width
	else:
		return position.x <= 0
