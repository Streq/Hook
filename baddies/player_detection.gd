extends Area2D

func _draw():
	var center = Vector2.ZERO
	var radius = $CollisionShape2D.shape.radius
	draw_circle(center, radius, Color(1,1,1,0.025))
	var half_vision_angle = get_parent().vision_angle/2
	RenderUtils.draw_circle_slice(self, center, radius, -half_vision_angle, half_vision_angle, Color(1,0,0,0.1))
