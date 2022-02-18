extends KinematicBody2D
signal landed()
signal returned()

export var speed := 1200
export var recoil := 50

var hit_body = null
var velocity := Vector2.ZERO

func _ready():
	velocity += Vector2(speed,0).rotated(rotation)

func _physics_process(delta):
	move_and_slide(velocity)


func _on_terrain_area_body_entered(body):
	velocity = Vector2.ZERO
	hit_body = body
	emit_signal("landed")
	


func _on_player_area_body_entered(body):
	emit_signal("returned")
	velocity = Vector2.ZERO
