extends Node

signal level_generated 

func _ready():
	randomize()

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
		
	# Generate fish
	for i in range(Constants.num_special_fish):
		var position = get_random_position(occupied_positions)
		spawn_special_fish(position)
		occupied_positions.append(position)

	print("Level generation complete")
	emit_signal("level_generated")

func get_random_position(occupied_positions: Array) -> Vector2:
	var position: Vector2
	var is_valid = false
	
	while not is_valid:
		position = Vector2(
			randf_range(Constants.BORDER_BUFFER, Constants.map_size.x - Constants.BORDER_BUFFER),
			randf_range(Constants.BORDER_BUFFER, Constants.map_size.y - Constants.BORDER_BUFFER)
		)
		is_valid = true

		for occupied in occupied_positions:
			if position.distance_to(occupied) < Constants.min_distance_between_objects:
				is_valid = false
				break

	return position

func spawn_fish(position: Vector2):
	var fish = Constants.fish_scene.instantiate()
	fish.add_to_group("fish")
	fish.set_script(load("res://scripts/fish.gd"))
	fish.position = position
	add_child(fish)
	print("Fish spawned at ", position)

func spawn_special_fish(position: Vector2):
	var special_fish = Constants.special_fish_scene.instantiate()
	special_fish.add_to_group("special_fish")
	special_fish.set_script(load("res://scripts/special_fish.gd"))
	special_fish.position = position
	add_child(special_fish)
	print("special_fish spawned at ", position)

func spawn_safezone(position: Vector2):
	var safezone = Constants.safezone_scene.instantiate()
	safezone.add_to_group("safezone")
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
