extends Node

func restart():
	get_tree().reload_current_scene()


func _input(event):
	if event.is_action_pressed("ui_end"):
		restart()
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
