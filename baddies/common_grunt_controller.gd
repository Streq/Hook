extends Node2D

export (NodePath) onready var input = get_node(input) as InputState

var target = null
var can_shoot = false
var noise_source = null


export var vision_angle := 90.0


enum Action{
	IDLE,
	LOOK_AT_NOISE,
	LOOK_AT_SOURCE_OF_NOISE,
	AIM_AND_SHOOT,
	WALK_TOWARDS
}
var current_action = Action.IDLE

func _physics_process(delta):
	
	var target_in_sight := is_instance_valid(target) and look_for_target()

	if target_in_sight:
		current_action = Action.AIM_AND_SHOOT
	match current_action:
		Action.IDLE:
			if is_instance_valid(noise_source):
				current_action = Action.LOOK_AT_NOISE
		Action.LOOK_AT_NOISE:
			var finish = !is_instance_valid(noise_source)
			if !finish:
				var noise_position := (noise_source as Node2D).global_position
				rotation = lerp_angle(rotation, rotation + get_angle_to(noise_source.global_position), 4.0*delta)
				if abs(get_angle_to(noise_position)) < deg2rad(1.0):
					if noise_source is Arrow:
						current_action = Action.LOOK_AT_SOURCE_OF_NOISE
					else:
						current_action = Action.IDLE
						noise_source = null
			if finish:
				current_action = Action.IDLE
				noise_source = null
		Action.LOOK_AT_SOURCE_OF_NOISE:
			var finish = !is_instance_valid(noise_source)
			if !finish:
				var arrow = (noise_source as Arrow)
				var dir = Vector2.RIGHT.rotated(arrow.global_rotation)
				var look_at_position = arrow.global_position - dir * 10000
				rotation = lerp_angle(rotation, rotation + get_angle_to(look_at_position), 4.0*delta)
				finish = abs(get_angle_to(look_at_position)) < deg2rad(1.0)
			if finish:
				current_action = Action.IDLE
				noise_source = null
		Action.WALK_TOWARDS:
			pass
		Action.AIM_AND_SHOOT:
			if target_in_sight:
				rotation = lerp_angle(rotation, rotation + get_angle_to(target.global_position), 6.0*delta)
				if $shoot_cooldown.is_stopped():
					$shoot_cooldown.start()
			else:
				noise_source = null
				current_action = Action.IDLE
				$shoot_cooldown.stop()
			
			input.set_action_pressed("shoot_arrow", can_shoot)
			
			can_shoot = false
	input.aim_angle = rotation
			
func _on_player_detection_body_entered(body):
	if is_instance_valid(body) and is_instance_valid(owner) and body.team != owner.team:
		target = body

func _on_player_detection_body_exited(body):
	if is_instance_valid(body) and is_instance_valid(owner) and body.team != owner.team:
		target = null

func look_for_target()->bool:
	if is_instance_valid(target):
			var angle = rad2deg(get_angle_to(target.global_position))
			if abs(angle) < vision_angle/2:
				var space_state = get_world_2d().direct_space_state
				var result = space_state.intersect_ray(get_parent().global_position, target.global_position, [get_parent()])
				return (result.has("collider") and result.collider == target)
	return false
	
func _on_shoot_cooldown_timeout():
	can_shoot = true


func _on_noise_detection_area_entered(area):
	noise_source = area.owner
