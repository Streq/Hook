extends Node


func _process(delta):
	pass
	print("idle_frame")

func _input(event):
	if event.is_action_pressed("shoot_hook"):
		print(name, " is shooting hook")
