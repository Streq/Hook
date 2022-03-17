extends Node2D
class_name LedgeGrab
export (NodePath) onready var input = get_node(input) as InputState
var can_grab = false

func _physics_process(delta):
	can_grab = input.dir.y <= 0.0 and owner.velocity.y >= 0.0
	if !can_grab:
		set_deferred("disabled", true)


func _on_ledge_check_ledge_entered():
	if can_grab:
		set_deferred("disabled", false)


func _on_ledge_check_ledge_exited():
	set_deferred("disabled", true)
