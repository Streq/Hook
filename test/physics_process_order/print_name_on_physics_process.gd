extends Node


func _physics_process(delta):
	print(name)
	pass


func _input(event):
	if event.is_action_pressed("shoot_arrow"):
		print(name, " is shooting arrow")
