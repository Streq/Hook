extends Area2D

func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color(0.4,0.4,0.4,0.4))
