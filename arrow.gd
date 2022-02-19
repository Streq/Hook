extends KinematicBody2D
signal landed()
signal returned()

export var speed := 1200
export var recoil := 50
export var gravity := Vector2(0,980.0)

var hit_body = null
var velocity := Vector2.ZERO
var caster = null

onready var hitbox = $hitbox
onready var player_area = $player_area

func _ready():
	velocity += Vector2(speed,0).rotated(rotation)

func _physics_process(delta):
	move_and_slide(velocity)
	if !hit_body:
		velocity += gravity*delta
#		velocity = lerp(velocity, Vector2.ZERO, delta*0.1)
		if !player_area.monitoring:
			rotation = velocity.angle()


func _on_terrain_area_body_entered(body):
	velocity = Vector2.ZERO
	hit_body = body
	player_area.set_deferred("monitoring", false)
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	emit_signal("landed")
	


func _on_player_area_body_entered(body):
	emit_signal("returned")
	velocity = Vector2.ZERO




func _on_hitbox_area_entered(area):
	if area.owner != caster:
		queue_free()
		area.owner.velocity += velocity*0.2
