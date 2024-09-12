extends Area2D

signal fish_entered 

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("fish_entered")
		queue_free()  
