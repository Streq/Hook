extends KinematicBody2D
signal landed()
signal returned()
signal bounced()

export var speed := 1200
export var recoil := 50
export var gravity := Vector2(0,980.0)

var hit_body = null
var velocity := Vector2.ZERO
var caster = null
var hurt_caster = false

onready var hitbox = $hitbox
onready var player_area = $player_area

func _ready():
	velocity += Vector2(speed,0).rotated(rotation)

func _physics_process(delta):
#	move_and_slide(velocity) 
	var collision := move_and_collide(velocity*delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)*0.9
		emit_signal("bounced")
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
		player_area.set_deferred("monitoring", false)
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		get_parent().remove_child(self)
		body.add_child(self)
		emit_signal("landed")


func _on_player_area_body_entered(body):
	if body == caster:
		emit_signal("returned")
		velocity = Vector2.ZERO




func _on_hitbox_area_entered(area):
	if area.owner != caster and !hurt_caster:
		queue_free()
#		area.owner.velocity += velocity*0.2
