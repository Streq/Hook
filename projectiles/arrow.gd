extends KinematicBody2D
class_name Arrow
signal landed()
signal loose()
signal returned()
signal bounced()
signal hit()

export var speed := 1200
export var recoil := 50
export var gravity := Vector2(0,490.0)
export var shooter_inertia := 0.0

var hit_body = null
var velocity := Vector2.ZERO
var caster = null
var hurt_caster = false
var landed = false

onready var hitbox = $hitbox
onready var player_area = $player_area
onready var terrain_area = $terrain_area

func _ready():
	emit_signal("loose")
func init(shooter, angle):
	caster = shooter
	global_rotation = angle + shooter.global_rotation
	position = shooter.position
	
	velocity += shooter.velocity*shooter_inertia
	
	var direction = Vector2(1,0).rotated(rotation)
	velocity += direction*speed
	shooter.velocity -= direction*recoil
	
func _physics_process(delta):
#	move_and_slide(velocity) 
	var collision := move_and_collide(velocity*delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)*0.9 
		if velocity.length_squared() > 50.0:
			emit_signal("bounced")
		else:
			queue_free()
		
		hurt_caster = true
	
	if !hit_body:
		velocity += gravity*delta
#		velocity = lerp(velocity, Vector2.ZERO, delta*0.1)
		if !player_area.monitoring:
			rotation = velocity.angle()


func _on_terrain_area_body_entered(body):
	if body.pierceable:
		velocity = Vector2.ZERO
		hit_body = body
		landed = true

		yield(get_tree(),"idle_frame")
		player_area.monitoring = false
		hitbox.monitoring = false
		hitbox.monitorable = false
		hitbox.get_node("CollisionShape2D").disabled = true
		terrain_area.monitoring = false
		terrain_area.monitorable = false
		terrain_area.get_node("CollisionShape2D").disabled = true
		get_parent().remove_child(self)
		body.add_child(self)
		emit_signal("landed")


func _on_player_area_body_entered(body):
	if body == caster:
		emit_signal("returned")
		velocity = Vector2.ZERO




func _on_hitbox_area_entered(area):
	if (area.owner != caster or hurt_caster) and area.tank_projectiles:
		emit_signal("hit")
		queue_free()
		
func _on_hitbox_area_exited(area):
	if area.owner == caster:
		 hurt_caster = true
