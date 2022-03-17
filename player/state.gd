extends Node

enum STATE {
	IDLE,
	RUN,
	JUMP,
	AIR,
	WALL,
	LEDGE_GRAB,
	WALL_JUMP,
	CLIMB_WALL
}


class IdleState extends State:
	func enter(args):
		pass
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

		pass
	func input(event):
		pass
