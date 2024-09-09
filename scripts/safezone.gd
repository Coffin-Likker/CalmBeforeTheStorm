extends Area2D

signal safezone_entered 
signal safezone_exited

func _ready():
	add_to_group("safezone")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("safezone_entered")

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal("safezone_exited")
