extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	var pause = !get_tree().paused
	get_tree().paused = pause
	visible = pause
