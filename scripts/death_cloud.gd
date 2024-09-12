extends Node2D

signal cloud_hit_player

@export var cloud_speed = 100
var move_direction = Vector2.ZERO
var is_moving = false
var screen_width = 0
var screen_height = 0
var cloud_width = 0
var cloud_height = 0
var camera = Node2D

func _ready():
	visible = false
	camera = get_node("../Camera2D")
	if not camera:
		print("Camera2D not found.")
		return
	
	var viewport_size = get_viewport_rect().size
	screen_width = viewport_size.x / camera.zoom.x
	screen_height = viewport_size.y / camera.zoom.y
	
	var used_rect = $CloudTilemap.get_used_rect()
	cloud_width = used_rect.size.x * $CloudTilemap.tile_set.tile_size.x
	cloud_height = used_rect.size.y * $CloudTilemap.tile_set.tile_size.y
	$CloudArea.body_entered.connect(Callable(self, "_on_cloud_body_entered"))

func _process(delta):
	if is_moving:
		position += move_direction * cloud_speed * delta
		if cloud_covers_screen():
			is_moving = false

func start_cloud_movement():
	visible = true
	is_moving = true
	#move_direction = direction
	var start_from_left = randf() > 0.5
	if start_from_left:
		position.x = camera.get_screen_center_position().x - (screen_width / 2) - cloud_width
		move_direction = Vector2.RIGHT
	else:
		position.x = camera.get_screen_center_position().x + (screen_width / 2)
		move_direction = Vector2.LEFT
	#if direction == Vector2.DOWN:
		#position.y = camera.get_screen_center_position().y - (screen_height / 2) - cloud_height
	#if direction == Vector2.UP:
		#position.y = camera.get_screen_center_position().y + (screen_height / 2)
	
	position.y = -10

func cloud_covers_screen() -> bool:
	var screen_center_x = camera.get_screen_center_position().x
	var screen_center_y = camera.get_screen_center_position().y

	if move_direction == Vector2.RIGHT:
		return position.x + cloud_width >= screen_center_x + (screen_width / 2) +10
	if move_direction == Vector2.LEFT:
		return position.x <= screen_center_x - (screen_width / 2) -10
	if move_direction == Vector2.UP:
		return position.y + cloud_height >= screen_center_y + (screen_height / 2) + 10
	else:
		return position.y <= screen_center_y - (screen_height / 2) - 10

func _on_cloud_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("cloud_hit_player")
