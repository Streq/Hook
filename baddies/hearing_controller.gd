extends Node2D

export (NodePath) onready var input = get_node(input) as InputState

var target = null
var shoot = false

export var vision_angle := 90.0


func _on_player_detection_body_entered(body):
	if is_instance_valid(body) and is_instance_valid(owner) and body.team != owner.team:
		target = body

func _on_player_detection_body_exited(body):
	if is_instance_valid(body) and is_instance_valid(owner) and body.team != owner.team:
		target = null

func look_for_target():
	if is_instance_valid(target):
			var angle = rad2deg(get_angle_to(target.global_position))
			if abs(angle) < vision_angle/2:
				var space_state = get_world_2d().direct_space_state
				var result = space_state.intersect_ray(get_parent().global_position, target.global_position, [get_parent()])
				return (result.has("collider") and result.collider == target)
	return false
	
func _on_shoot_cooldown_timeout():
	shoot = true
