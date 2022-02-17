extends Node2D
signal landed()

export var speed := 600
export var recoil := 300

var hit_body
var velocity := Vector2.ZERO

func _physics_process(delta):
	move_local_x(speed*delta)


func _on_Area2D_body_entered(body):
	speed = 0
	hit_body = body
	emit_signal("landed")
	
