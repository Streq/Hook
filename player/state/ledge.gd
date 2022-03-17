extends State
class_name LedgeState

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
	
	p.sprite.flip_h = right_ledge.disabled
	
	p.velocity = p.move_and_slide(p.velocity, Vector2.UP)
	p.velocity += p.gravity*delta
	
	
	if right_ledge.disabled and left_ledge.disabled:
		_finish("idle")
	
	if p.get_jump():
		_jump(p, dir)
	
	
	
	pass
func _jump(p: Player, dir):
	p.velocity.y -= p.jump_speed * Math.sqrt_2_inv
	p.velocity.x += dir.x*p.jump_speed * Math.sqrt_2_inv
	p.get_node("step_sound").play()
		
func input(event):
	pass
