extends Node2D


var points := PoolVector2Array()
var colors := PoolColorArray()
var gravity := Vector2(0, 0)
var speed := 0.0
var shooter_inertia := 0.0

var color_within_range = Color(1,1,0,1)
var color_outside_range = Color(1,0,0,1)
var projectile_prototype = null

func _ready():
	points.resize(120)
	colors.resize(120)
	

func _physics_process(delta):
	var p : Vector2 = Vector2.ZERO
	var shooter = get_parent()
	var velocity = Vector2(1,0).rotated(shooter.input.aim_angle)*speed + shooter.get_parent().velocity*shooter_inertia
	var max_length_squared = shooter.max_rope_length*shooter.max_rope_length
	for i in points.size():
		p += velocity*delta
		velocity += gravity*delta
		points[i] = p
#		if i%2 != 0:
#			colors[i] = Color.transparent
		if p.length_squared() < max_length_squared:
			colors[i] = color_within_range
		else:
			colors[i] = color_outside_range
	update()
func _draw():
#	draw_multiline_colors(points,colors)
	for i in points.size()-1:
#		draw_primitive([points[i],points[i+1]],[colors[i],colors[i]],[])
#		draw_line(points[i],points[i+1],colors[i],5.0)
		draw_rect(Rect2(points[i],Vector2(2,2)),colors[i])
func _on_shooter_ready():
	projectile_prototype = get_parent().ARROW.instance()
	gravity = projectile_prototype.gravity
	speed = projectile_prototype.speed
	shooter_inertia = projectile_prototype.shooter_inertia
	
	
