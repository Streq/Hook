extends Node

func reparent_deferred(node:Node, new_parent:Node):
	call_deferred("reparent", node, new_parent)
func reparent(node:Node, new_parent:Node):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)

func reparent_and_keep_transform_deferred(node:Node2D, new_parent:Node):
	call_deferred("reparent_and_keep_transform", node, new_parent)
func reparent_and_keep_transform(node:Node2D, new_parent:Node):
	var t = node.global_transform
	var old_parent = node.get_parent()
	old_parent.remove_child(node)
	new_parent.add_child(node)
	node.global_transform = t
