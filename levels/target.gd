extends Node2D

signal hit()

func _on_hurtbox_area_entered(area):
	emit_signal("hit")
	queue_free()
