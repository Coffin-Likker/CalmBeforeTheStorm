extends Area2D

signal special_fish_entered 

func _ready():
	add_to_group("special_fish")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("special_fish_entered")
		queue_free()  
