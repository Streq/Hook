extends Node

var input = null

func _on_controlled_ready():
	input = get_parent().input
	in_focus()

func in_focus():
	for action in input.get_actions():
		input.set_action_pressed(action, Input.is_action_pressed(action))

func out_of_focus():
	for action in input.get_actions():
		input.set_action_pressed(action, false)

func _process(delta):
	input.dir = Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)

func _notification(what): #just in case, idk if this is needed
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		in_focus()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		out_of_focus()
		pass


func _input(event):
	if event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		var mouse_viewport_position := e.position
		var player_viewport_position := (get_parent() as Node2D).get_global_transform_with_canvas().origin
		input.aim_angle = (mouse_viewport_position-player_viewport_position).angle()
	
	for action in input.get_actions():
		if event.is_action(action):
			input.set_action_pressed(action, event.is_pressed())
			return
		
		
