extends Area2D

var current_target = null

func _on_noise_entered(area):
	current_target = area.owner
