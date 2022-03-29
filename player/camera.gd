extends Node2D

var move = false

func _process(delta):
	var vp = get_viewport()
#	if Input.is_action_just_pressed("look"):
#		move = !move
	if Input.is_action_pressed("look"):
		position = lerp(position, (vp.get_mouse_position()-vp.size*0.5), 60*delta)
	else:
		position = Vector2.ZERO
	
