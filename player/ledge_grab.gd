extends Node2D

export (NodePath) onready var input = get_node(input) as InputState
var can_grab = false

func _physics_process(delta):
	if input.dir.y>0:
		set_deferred("disabled", true)
