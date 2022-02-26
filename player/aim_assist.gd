extends Node2D


var points := PoolVector2Array()
var colors := PoolColorArray()
var gravity := Vector2(0, 0)
var speed := 0.0
var shooter_inertia := 0.0

var color_within_range = Color(0.5,0.75,0.5,0.5)
var color_outside_range = Color(0.75,0.0,0.0,0.5)
var projectile_prototype = null

func _ready():
	points.resize(120)
	colors.resize(120)
	

func _physics_process(delta):
	var p : Vector2 = Vector2.ZERO
	var shooter = get_parent()
	var velocity = Vector2(1,0).rotated(shooter.input.aim_angle)*speed + shooter.velocity*shooter_inertia
	var max_length_squared = shooter.max_rope_length*shooter.max_rope_length
	for i in points.size():
		p += velocity*delta
		velocity += gravity*delta
		points[i] = p
		if p.length_squared() < max_length_squared:
			colors[i] = color_within_range
		else:
			colors[i] = color_outside_range
	update()
func _draw():
	draw_polyline_colors(points,colors)


func _on_shooter_ready():
	projectile_prototype = get_parent().ARROW.instance()
	gravity = projectile_prototype.gravity
	speed = projectile_prototype.speed
	shooter_inertia = projectile_prototype.shooter_inertia
	
	
