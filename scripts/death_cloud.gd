extends Node2D

signal cloud_hit_player

@export var cloud_speed = 100
var move_direction = Vector2.ZERO
var is_moving = false
var screen_width = 0
var screen_height = 0
var cloud_width = 0
var cloud_height = 0
var camera: Camera2D

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
			print('cloud stop moving')
			is_moving = false

func start_cloud_movement(direction):
	visible = true
	is_moving = true
	move_direction = direction
	var screen_center = camera.get_screen_center_position()
	
	match direction:
		Vector2.RIGHT:
			position.x = screen_center.x - (screen_width / 2) - cloud_width - 10
			position.y = -10
		Vector2.LEFT:
			position.x = screen_center.x + (screen_width / 2) + 10
			position.y = -10
		Vector2.DOWN:
			position.x = -10
			position.y = screen_center.y - (screen_height / 2) - cloud_height - 10
		Vector2.UP:
			position.x = -10
			position.y = screen_center.y + (screen_height / 2) + 10

func cloud_covers_screen() -> bool:
	var screen_center = camera.get_screen_center_position()
	
	match move_direction:
		Vector2.RIGHT:
			return position.x + cloud_width >= screen_center.x + (screen_width / 2) + 10
		Vector2.LEFT:
			return position.x <= screen_center.x - (screen_width / 2) - 10
		Vector2.DOWN:
			return position.y + cloud_height >= screen_center.y + (screen_height / 2) + 10
		Vector2.UP:
			return position.y <= screen_center.y - (screen_height / 2) - 10
	
	return false

func _on_cloud_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("cloud_hit_player")
