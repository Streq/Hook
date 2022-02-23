extends Node


func _physics_process(delta):
	get_parent().velocity += InputUtils.get_input_dir() * 1500 * delta
