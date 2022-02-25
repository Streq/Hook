extends Camera2D

func _process(delta):
	var vp = get_viewport()
	position = lerp(position, (vp.get_mouse_position()-vp.size*0.5)*zoom, 6*delta)
	
