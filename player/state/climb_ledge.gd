extends State
class_name ClimbLedgeState

var right_ledge : CollisionShape2D
var left_ledge : CollisionShape2D
var done = false
onready var tween : Tween = $Tween 
func enter(args):
	right_ledge = owner.get_node("right_ledge_grab")
	left_ledge = owner.get_node("left_ledge_grab")
	done = false
	
func update(delta:float):
	if done:
		return
	
	done = true
	var p = owner as Player
	var ledge_dir = float(!right_ledge.disabled) - float(!left_ledge.disabled)
	var ledge = right_ledge if !right_ledge.disabled else left_ledge
	
	var final_pos = ledge.global_position - Vector2(-ledge_dir*5.0, 12.0)
	tween.interpolate_property(p,"global_position",p.global_position, Vector2(p.global_position.x, final_pos.y), 0.2,Tween.TRANS_LINEAR)
	tween.interpolate_property(owner.sprite,"position",owner.sprite.position, Vector2(0.0, 4.0),0.2,Tween.TRANS_LINEAR)
	
	
	tween.start()
	yield(tween,"tween_completed")
	yield(get_tree(),"idle_frame")#so "tween_completed" doesn't match both yields
	owner.animation.play("air")
	owner.sprite.rotation_degrees = 90*owner.facing_dir
	tween.interpolate_property(p,"global_position",p.global_position, Vector2(final_pos.x, p.global_position.y), 0.1, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween,"tween_completed")
	
	
	yield(get_tree().create_timer(0.1), "timeout")
	p.sprite.rotation_degrees = 0
	p.sprite.position = Vector2(0.0, 0.0)
	
	_finish("idle")
	
