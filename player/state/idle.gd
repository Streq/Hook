extends State
class_name IdleState

var right_ledge
var left_ledge

func enter(args):
	right_ledge = owner.get_node("right_ledge_grab")
	left_ledge = owner.get_node("left_ledge_grab")
	
func exit():
	pass
func update(delta:float):
	var p := owner as Player
	var dir : Vector2 = p.get_input_dir()
	p.facing_dir = dir.x
	var initial_velocity = p.velocity+dir*0.01
	p.velocity = p.move_and_slide(initial_velocity, Vector2.UP)
	p.check_death_worthy_collision(initial_velocity)
	
	p.velocity += p.gravity*delta
	p.can_interact = p.is_on_floor() and !is_instance_valid(p.shooter.rope)
	p._move(dir, delta)
	if p.get_jump():
		p._jump(dir)
	
	if !right_ledge.disabled or !left_ledge.disabled:
		var ledge_dir = float(!right_ledge.disabled) - float(!left_ledge.disabled)
		if !p.feet_on_the_ground() or dir.x == ledge_dir:
			_finish("ledge")
		

	pass
func input(event):
	pass
