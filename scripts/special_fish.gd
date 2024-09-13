extends Area2D

signal fish_entered(fish)

func _ready():
	add_to_group("special_fish")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("fish_entered", self)
		queue_free()
