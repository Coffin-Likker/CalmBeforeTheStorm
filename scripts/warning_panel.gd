extends Control


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
			self.set_position(Vector2(2040, 525))
		Vector2.DOWN:
			self.set_position(Vector2(842, 40))
		Vector2.UP:
			self.set_position(Vector2(842, 1130))
	self.show()
