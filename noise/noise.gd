extends Area2D


enum TYPE {
	ARROW,
	YELL
}

export (TYPE) var type := TYPE.ARROW
export var duration := 0.2

onready var shape : CollisionShape2D = $CollisionShape2D

func activate():
	shape.set_deferred("disabled", false)
	yield(get_tree().create_timer(duration),"timeout")
	shape.set_deferred("disabled", true)
	
