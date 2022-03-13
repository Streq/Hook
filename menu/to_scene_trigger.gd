extends Button

export (String, FILE) var to

func trigger():
	get_tree().change_scene(to)
