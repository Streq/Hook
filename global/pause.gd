extends CanvasLayer

var pause = false

func _ready():
	update_state()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
	
func toggle_pause():
	pause = !get_tree().paused
	update_state()

func update_state():
	get_tree().paused = pause
	$menu.visible = pause
	set_process_input(pause)
