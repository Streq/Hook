extends Node

func reparent(node:Node2D, new_parent:Node):
	var t = node.global_transform
	var old_parent = node.get_parent()
	old_parent.remove_child(node)
	new_parent.add_child(node)
	node.global_transform = t
func reparent_deferred(node:Node2D, new_parent:Node):
	call_deferred("reparent", node, new_parent)
