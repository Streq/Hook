extends Node2D

var pointA : Node2D = null
var pointB : Node2D = null
export var length := 300.0



func _physics_process(delta):
	if is_instance_valid(pointA) and is_instance_valid(pointB):
		var bodyA = pointA.get_parent()
		var bodyB = pointB.get_parent()
		
		var dist = (pointB.global_position - pointA.global_position)
		if dist.length_squared() > length*length:
			var arrow = bodyB
			var norm = dist.normalized()
				
			if is_instance_valid(arrow.hit_body):
#				bodyA.velocity += dist.normalized() * delta * 10000
#				bodyA.velocity += norm*25*(min(50.0*50.0, dist.length_squared()-length*length)/(50.0*50.0))
				bodyA.velocity += norm*25 #bodyA.move_and_slide(norm*100,Vector2.UP)
				var projection : Vector2 = bodyA.velocity.project(norm)
#				print(projection.dot(norm))
				if projection.dot(norm) < 0:
					bodyA.velocity -= projection
				pass
			else:
				arrow.velocity -= norm*300
				arrow.velocity = lerp(arrow.velocity, Vector2.ZERO, delta*8)
				var projection : Vector2 = arrow.velocity.project(norm)
				if projection.dot(norm) < 0:
					length = 0.0
#					arrow.modulate = Color.purple
					arrow.get_node("player_area").set_deferred("monitoring", true)
#					arrow.get_node("terrain_area").set_deferred("monitoring", false)
		
		update_display()


func update_display():
	$display.global_position = (pointA.global_position + pointB.global_position) / 2
	var dist = (pointA.global_position - pointB.global_position)
	$display.rotation = (pointA.global_position - pointB.global_position).angle()
	$display.scale.x = dist.length()
	if dist.length_squared() > length*length:
		$display.modulate = Color.red
	else:
		$display.modulate = Color.green
