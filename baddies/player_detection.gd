extends Area2D



func draw_circle_slice(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(Vector2.ZERO)
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

#	for index_point in range(nb_points):
#		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
	draw_colored_polygon(points_arc,color)

func _draw():
	var center = Vector2.ZERO
	var radius = $CollisionShape2D.shape.radius
	draw_circle(center, radius, Color(1,1,1,0.025))
	var half_vision_angle = get_parent().vision_angle/2
	draw_circle_slice(center, radius, -half_vision_angle, half_vision_angle, Color(1,0,0,0.1))
	
	
