extends AudioStreamPlayer2D

func play(from_position: float = 0.0):
	if is_instance_valid(owner):
		var new_parent = owner.get_parent()
		var t = global_transform
		owner.remove_child(self)
		new_parent.add_child(self)
		global_transform = t
		connect("finished", self, "queue_free")
		.play(from_position)
	
