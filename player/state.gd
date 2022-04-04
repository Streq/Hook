extends Node

#enum STATE {
#COULD ALL BE ONE STATE FOR SIMPLICITY
#	IDLE,
#	RUN,
#	JUMP,
#	AIR,
#	WALL,
#	WALL_JUMP,

#ANOTHER STATE
#	LEDGE_GRAB,
#	CLIMB_WALL
#}

#
#class IdleState extends State:
#	var right_ledge
#	var left_ledge
#
#	func enter(args):
#		right_ledge = owner.get_node("ledge_grab2")
#		left_ledge = owner.get_node("ledge_grab")
#
#	func exit():
#		pass
#	func update(delta:float):
#		var p := owner as Player
#		var dir : Vector2 = p.get_input_dir()
#		if dir.x:
#			p.sprite.flip_h = dir.x < 0.0
#		p.velocity = p.move_and_slide(p.velocity+dir*0.01, Vector2.UP)
#		p.velocity += p.gravity*delta
#
#		p._move(dir, delta)
#		if p.get_jump():
#			p._jump(dir)
#
#
#
#		pass
#	func input(event):
#		pass
#
#
#class LedgeState extends State:
#	var right_ledge
#	var left_ledge
#
#	func enter(args):
#		right_ledge = owner.get_node("ledge_grab2")
#		left_ledge = owner.get_node("ledge_grab")
#	func exit():
#		pass
#	func update(delta:float):
#		var p := owner as Player
#		var dir : Vector2 = p.get_input_dir()
#
#		p.sprite.flip_h = right_ledge.disabled
#
#		p.velocity = p.move_and_slide(p.velocity, Vector2.UP)
#		p.velocity += p.gravity*delta
#
#		p._move(dir, delta)
#
#		if right_ledge.disabled and left_ledge.disabled:
#			_finish("air")
#
#		if p.get_jump():
#			_jump(p, dir)
#
#
#
#		pass
#	func _jump(p: Player, dir):
#		p.velocity.y -= p.jump_speed * Math.sqrt_2_inv
#		p.velocity.x += dir.x*p.jump_speed * Math.sqrt_2_inv
#		p.get_node("step_sound").play()
#
#	func input(event):
#		pass
