extends Node2D


func _physics_process(delta):
	rotation = get_parent().input.aim_angle
