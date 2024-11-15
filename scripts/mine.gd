extends Area2D

signal mine_hit

func _ready():
	add_to_group("mine")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("mine_hit")
