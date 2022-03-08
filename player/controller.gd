extends Node

onready var input = get_parent().get_node("input")

func _ready():
	in_focus()

func in_focus():
	for action in input.get_actions():
		input.set_action_pressed(action, Input.is_action_pressed(action))

func out_of_focus():
	for action in input.get_actions():
		input.set_action_pressed(action, false)

func _physics_process(delta):
	input.dir = InputUtils.get_input_dir()
	input.aim_angle = InputUtils.get_dist_to_mouse(get_parent()).angle()

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
