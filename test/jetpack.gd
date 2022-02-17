extends Node2D


func _physics_process(delta):
	get_parent().velocity += get_input_dir() * 1500 * delta
	
func get_input_dir() -> Vector2:
	return Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)
