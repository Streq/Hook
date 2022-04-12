extends Node

#export (NodePath) onready var spawn_point = get_node(spawn_point).global_position as Vector2


func trigger():
	Global.restart()
#	owner.global_position = spawn_point
#	owner.velocity = Vector2()
