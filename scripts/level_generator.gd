extends Node2D

signal level_generated 
signal fish_spawned(fish_instance)

var occupied_positions = []

func _ready():
	randomize()

func generate_level():
	clear_level()
	occupied_positions.clear()
	
	# Add center position as occupied to create safe zone for player
	occupied_positions.append(Vector2(Constants.map_size.x / 2, Constants.map_size.y / 2))
	
	for i in range(Constants.num_safezones):
		var position = get_random_position()
		spawn_safezone(position)
		occupied_positions.append(position)
	
	for i in range(Constants.total_fish_on_screen):
		spawn_random_fish()

	print("Level generation complete")
	emit_signal("level_generated")

func get_random_position() -> Vector2:
	var position: Vector2
	var is_valid = false
	var center = Vector2(Constants.map_size.x / 2, Constants.map_size.y / 2)
	
	while not is_valid:
		position = Vector2(
			randf_range(Constants.BORDER_BUFFER, Constants.map_size.x - Constants.BORDER_BUFFER),
			randf_range(Constants.BORDER_BUFFER, Constants.map_size.y - Constants.BORDER_BUFFER)
		)
		is_valid = true
		
		if position.distance_to(center) < Constants.CENTER_SAFE_RADIUS:
			is_valid = false
			continue
		
		for occupied in occupied_positions:
			if position.distance_to(occupied) < Constants.min_distance_between_objects:
				is_valid = false
				break
	
	return position

func spawn_random_fish():
	var position = get_random_position()
	var is_special = randf() < Constants.special_fish_spawn_chance
	
	if is_special:
		spawn_special_fish(position)
	else:
		spawn_fish(position)
	
	occupied_positions.append(position)

func spawn_fish(position: Vector2):
	var fish = Constants.fish_scene.instantiate()
	fish.set_script(load("res://scripts/fish.gd"))
	fish.position = position
	fish.add_to_group("fish")
	add_child(fish)
	print("Fish spawned at ", position)
	emit_signal("fish_spawned", fish)

func spawn_special_fish(position: Vector2):
	var special_fish = Constants.special_fish_scene.instantiate()
	special_fish.set_script(load("res://scripts/special_fish.gd"))
	special_fish.position = position
	special_fish.add_to_group("special_fish")
	add_child(special_fish)
	print("Special fish spawned at ", position)
	emit_signal("fish_spawned", special_fish)

func spawn_safezone(position: Vector2):
	var safezone = Constants.safezone_scene.instantiate()
	safezone.set_script(load("res://scripts/safezone.gd"))
	safezone.position = position
	safezone.add_to_group("safezone")
	add_child(safezone)
	print("Safezone spawned at ", position)

func clear_level():
	for child in get_children():
		child.queue_free()
	occupied_positions.clear()

func regenerate_level():
	clear_level()
	generate_level()
