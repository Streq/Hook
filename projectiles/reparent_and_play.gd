extends AudioStreamPlayer2D

func play(from_position: float = 0.0):
	var new_parent = owner.get_parent()
	owner.remove_child(self)
	new_parent.add_child(self)
	connect("finished", self, "queue_free")
	.play(from_position)
	
