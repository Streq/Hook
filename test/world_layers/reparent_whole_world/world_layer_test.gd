extends Node2D
onready var current_node = $Node2D2
onready var offscreen_node = $Viewport/Node2D


func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		var scene = current_node.get_parent()
		var offscreen = offscreen_node.get_parent()
		
		NodeUtils.reparent_and_keep_transform(current_node, offscreen)
		NodeUtils.reparent_and_keep_transform(offscreen_node, scene)
		
		var aux = offscreen_node
		offscreen_node = current_node
		current_node = aux

