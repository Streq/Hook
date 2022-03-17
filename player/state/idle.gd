extends State
class_name IdleState

var right_ledge
var left_ledge

func enter(args):
	right_ledge = owner.get_node("ledge_grab2")
	left_ledge = owner.get_node("ledge_grab")
	
func exit():
	pass
func update(delta:float):
	var p := owner as Player
	var dir : Vector2 = p.get_input_dir()
	if dir.x:
		p.sprite.flip_h = dir.x < 0.0
	p.velocity = p.move_and_slide(p.velocity+dir*0.01, Vector2.UP)
	p.velocity += p.gravity*delta
	
	p._move(dir, delta)
	if p.get_jump():
		p._jump(dir)

	if !right_ledge.disabled or !left_ledge.disabled:
		_finish("ledge")
		

	pass
func input(event):
	pass
