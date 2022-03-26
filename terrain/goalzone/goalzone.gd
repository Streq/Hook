extends Area2D



func _on_goalzone_body_entered(body):
	Levels.next_level()
