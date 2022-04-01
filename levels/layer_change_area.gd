extends Area2D
export var direction := 1


func _on_body_entered(body:PhysicsBody2D):
	var root = get_tree().get_nodes_in_group("level_root")[0]
	if !body.is_connected("interact", root, "change_layer"):
		body.connect("interact", root, "change_layer", [direction])
func _on_body_exited(body:PhysicsBody2D):
	var root = get_tree().get_nodes_in_group("level_root")[0]
	if body.is_connected("interact", root, "change_layer"):
		body.disconnect("interact", root, "change_layer")
