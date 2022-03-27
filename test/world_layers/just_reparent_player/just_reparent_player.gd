extends CanvasLayer
export (NodePath) onready var onscreen_vp = get_node(onscreen_vp) as Viewport
export (NodePath) onready var offscreen_vp = get_node(offscreen_vp) as Viewport

export (NodePath) onready var player = get_node(player) as Node2D
export (NodePath) onready var camera = get_node(camera) as Camera2D


func _ready():
	offscreen_vp.get_parent().visible = false
	onscreen_vp.get_parent().visible = true
	NodeUtils.reparent_and_keep_transform_deferred(player, onscreen_vp)
	camera.current = true
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		switch()
func switch():
	var aux = onscreen_vp
	onscreen_vp = offscreen_vp
	offscreen_vp = aux
	
	offscreen_vp.get_parent().visible = false
	onscreen_vp.get_parent().visible = true
	NodeUtils.reparent_and_keep_transform_deferred(player, onscreen_vp)
	camera.current = true
