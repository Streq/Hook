extends CanvasLayer

export (NodePath) onready var onscreen_vp = get_node(onscreen_vp) as Viewport
export (NodePath) onready var offscreen_vp = get_node(offscreen_vp) as Viewport
export (NodePath) onready var change_area0 = get_node(change_area0) as Area2D
export (NodePath) onready var change_area1 = get_node(change_area1) as Area2D

export (NodePath) onready var player = get_node(player) as Node2D
export (NodePath) onready var camera = get_node(camera) as Camera2D


func _ready():
	update_display()
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if player.can_interact and is_touching_change_area(player):
			switch()
func switch():
	var aux = onscreen_vp
	onscreen_vp = offscreen_vp
	offscreen_vp = aux
	NodeUtils.reparent_and_keep_transform_deferred(player, onscreen_vp)
	update_display()
	
func update_display():
	offscreen_vp.get_parent().visible = false
	offscreen_vp.audio_listener_enable_2d = false
	onscreen_vp.get_parent().visible = true
	onscreen_vp.audio_listener_enable_2d = true
	camera.current = true
func is_touching_change_area(who):
	return change_area0.overlaps_body(who) or change_area1.overlaps_body(who)
