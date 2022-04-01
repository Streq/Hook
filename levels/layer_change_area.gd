extends Area2D
export var direction := 1


func _on_body_entered(body:PhysicsBody2D):
#	print(body.name, " entered ", name)
	if !body.is_connected("interact", self, "change_layer"):
		body.connect("interact", self, "change_layer")
func _on_body_exited(body:PhysicsBody2D):
#	print(body.name, " exited ", name)
	if body.is_connected("interact", self, "change_layer"):
		body.disconnect("interact", self, "change_layer")

func change_layer():
	var root = get_tree().get_nodes_in_group("level_root")[0]
	root.change_layer(direction)
