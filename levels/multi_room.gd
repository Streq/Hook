extends CanvasLayer

export (NodePath) onready var inside = get_node(inside) as Viewport
export (NodePath) onready var outside = get_node(outside) as Viewport
export (NodePath) onready var change_area0 = get_node(change_area0) as Area2D
export (NodePath) onready var change_area1 = get_node(change_area1) as Area2D

export (NodePath) onready var player = get_node(player) as Node2D
export (NodePath) onready var camera0 = get_node(camera0) as Camera2D
export (NodePath) onready var camera1 = get_node(camera1) as Camera2D
export (NodePath) onready var remote_transform0 = get_node(remote_transform0) as RemoteTransform2D
export (NodePath) onready var remote_transform1 = get_node(remote_transform1) as RemoteTransform2D

var is_outside = false

func _ready():
	update_display()
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if player.can_interact and is_touching_change_area(player):
			switch()
func switch():
#	var aux = onscreen_vp
#	onscreen_vp = offscreen_vp
#	offscreen_vp = aux
	if is_outside:
		NodeUtils.reparent_and_keep_transform_deferred(player, inside)
		outside.get_parent().visible = false
	else:
		NodeUtils.reparent_and_keep_transform_deferred(player, outside)
		outside.get_parent().visible = true
	is_outside = !is_outside
	
	update_display()
	
func update_display():
#	offscreen_vp.get_parent().visible = false
	outside.audio_listener_enable_2d = true
#	onscreen_vp.get_parent().visible = true
	inside.audio_listener_enable_2d = true
#	camera0.current = true
#	camera1.current = true
	remote_transform0.remote_path = camera0.get_path()
	remote_transform1.remote_path = camera1.get_path()
func is_touching_change_area(who):
	return change_area0.overlaps_body(who) or change_area1.overlaps_body(who)
