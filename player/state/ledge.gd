extends State
class_name LedgeState

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
	
	var ledge_dir = float(!right_ledge.disabled) - float(!left_ledge.disabled)
	var ledge = left_ledge if ledge_dir<0 else right_ledge
	
	p.can_interact = false
	p.animation.play("idle")
	
	
	p.facing_dir = dir.x if dir.x else ledge_dir
	
	var fix_dir = Vector2(50.0*ledge_dir, 0)
	
	p.velocity = p.move_and_slide(p.velocity + fix_dir, Vector2.UP)
	p.velocity += p.gravity*delta
	
	
	if right_ledge.disabled and left_ledge.disabled or p.feet_on_the_ground() and dir.x != ledge_dir:
		_finish("idle")
	
	if p.get_jump():
		if dir.x != ledge_dir or !ledge_dir:
			_jump(p, dir)
		elif ledge.can_climb:
			_finish("climb_ledge")
	
	
	
	pass
func _jump(p: Player, dir):
	p.velocity.y -= p.jump_speed * Math.sqrt_2_inv
	p.velocity.x += dir.x*p.jump_speed * Math.sqrt_2_inv
	p.get_node("step_sound").play()
		
func input(event):
	pass
