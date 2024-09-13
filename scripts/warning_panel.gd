extends Control

var flash_count = 0
var max_flashes = 5
var flash_duration = 0.6
var flash_interval = 0.6
var is_flashing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func trigger_panel(direction):
	match direction:
		Vector2.RIGHT:
			self.set_position(Vector2(40, 525))
		Vector2.LEFT:
			self.set_position(Vector2(1640, 525))
		Vector2.DOWN:
			self.set_position(Vector2(842, 40))
		Vector2.UP:
			self.set_position(Vector2(842, 1030))
	start_flashing()

func start_flashing():
	if not is_flashing:
		is_flashing = true
		flash_count = 0
		_flash()

func _flash():
	flash_count += 1
	print('flash count: ', flash_count)
	if flash_count <= max_flashes:
		self.show()
		get_tree().create_timer(flash_duration).timeout.connect(_on_flash_visible_timeout)
	else:
		is_flashing = false

func _on_flash_visible_timeout():
	self.hide()
	get_tree().create_timer(flash_interval).timeout.connect(_flash)
