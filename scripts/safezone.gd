extends Area2D

signal safezone_entered

func _ready():
	add_to_group("safezone")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("safezone_entered")
