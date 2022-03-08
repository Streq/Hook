extends State

func update(delta:float):
	var hearing = owner.get_node("hearing")
	var target = hearing.current_target
	if is_instance_valid(target):
		emit_signal("finished", "heard_noise", [target])
	hearing.current_target = null
