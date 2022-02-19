extends Node2D

var input : InputState = null

var target = null
var shoot = false

func _on_controlled_ready():
	input = get_parent().input

func _physics_process(delta):
	if is_instance_valid(target) and look_for_target():
		if $shoot_cooldown.is_stopped():
#			shoot = true
			$shoot_cooldown.start()
	else:
		$shoot_cooldown.stop()
			
	if shoot and is_instance_valid(target):
		input.aim_angle = to_local(target.global_position).angle()
		input.set_action_pressed("shoot_arrow", true)
	else:
		input.set_action_pressed("shoot_arrow", false)
	shoot = false

func _on_player_detection_body_entered(body):
	if body != owner:
		target = body

func _on_player_detection_body_exited(body):
	if body != owner:
		target = null

func look_for_target():
	if is_instance_valid(target):
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(get_parent().global_position, target.global_position, [get_parent()])
		print(result.collider.name)
		return (result.has("collider") and result.collider == target)

func _on_shoot_cooldown_timeout():
	shoot = true
