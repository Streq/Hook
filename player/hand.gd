extends Sprite

func _physics_process(delta):
	visible = !get_parent().disabled
