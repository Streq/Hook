extends Camera2D

func _process(delta):
	var vp = get_viewport()
	position = lerp(position, (vp.get_mouse_position()-vp.size*0.5)/global_scale, 6*delta)
	
