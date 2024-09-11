extends Node

signal level_generated 

var fish_scene: PackedScene
var safezone_scene: PackedScene

func _ready():
	randomize()
	fish_scene = load("res://scenes/fish.tscn")
	safezone_scene = load("res://scenes/safezone.tscn")

func generate_level():
	clear_level()
	var occupied_positions = []
	
	# Generate safezones
	for i in range(Constants.num_safezones):
		var position = get_random_position(occupied_positions)
		spawn_safezone(position)
		occupied_positions.append(position)
	
	# Generate fish
	for i in range(Constants.num_fish):
		var position = get_random_position(occupied_positions)
		spawn_fish(position)
		occupied_positions.append(position)
		
	print("Level generation complete")
	emit_signal("level_generated")

func get_random_position(occupied_positions: Array) -> Vector2:
	var position: Vector2
	var is_valid = false
	
	while not is_valid:
		position = Vector2(
			randf_range(0, Constants.map_size.x),
			randf_range(0, Constants.map_size.y)
		)
		is_valid = true
		
		for occupied in occupied_positions:
			if position.distance_to(occupied) < Constants.min_distance_between_objects:
				is_valid = false
				break
	
	return position

func spawn_fish(position: Vector2):
	var fish = fish_scene.instantiate()
	fish.set_script(load("res://scripts/fish.gd"))
	fish.position = position
	add_child(fish)
	print("Fish spawned at ", position)

func spawn_safezone(position: Vector2):
	var safezone = safezone_scene.instantiate()
	safezone.set_script(load("res://scripts/safezone.gd"))
	safezone.position = position
	add_child(safezone)
	print("Safezone spawned at ", position)

func clear_level():
	for child in get_children():
		child.queue_free()

func regenerate_level():
	clear_level()
	generate_level()
