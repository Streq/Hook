extends Node
class_name State

signal finished(new_state_name, args)

func _finish(new_state_name, args = []):
	emit_signal("finished", new_state_name, args)

func enter(args):
	pass
func exit():
	pass
func update(delta:float):
	pass
func input(event):
	pass
