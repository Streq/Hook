extends CanvasLayer
class_name LevelRoot
onready var layers_node = $layers
onready var tween := $Tween as Tween
var current_layer := 0

const DARKEN_FACTOR := 0.2
export (NodePath) onready var player = get_node(player) as Player

func _ready():
	var layers = layers_node.get_children()
	for i in layers.size():
		var layer := layers[i] as Node
		NodeUtils.reparent(layer.camera_remote_transform, player)
		if layer.is_a_parent_of(player):
			current_layer = i
	set_current_layer(current_layer)
	update_display()

func update_display():
	var layers = layers_node.get_children()
	layers_node.offset = Vector2.ZERO
	for i in layers.size():
		var layer := layers[i] as LevelLayer
		layer.viewport.audio_listener_enable_2d = true
		layer.camera.position = (i-current_layer)*Global.ISOMETRIC_OFFSET
		layer.camera_remote_transform.remote_path = layer.camera_pivot.get_path()
	
	var darkness := Color.white
	#foreground layers
	for i in range(current_layer+1, layers.size()):
		var layer := layers[i] as LevelLayer
		layer.visible = false
		darkness = darkness.darkened(DARKEN_FACTOR)
		layer.self_modulate = darkness
	darkness =  Color.white
	#background layers
	for i in range(current_layer-1, -1, -1):
		var layer := layers[i] as LevelLayer
		layer.visible = true
		darkness = darkness.darkened(DARKEN_FACTOR)
		layer.self_modulate = darkness
	var layer := layers[current_layer] as LevelLayer
	layer.visible = true
	layer.self_modulate = Color.white
	
func change_layer(dir):
	var layers = $layers.get_children()
	var old_layer = layers[current_layer] as LevelLayer
	
	set_current_layer(current_layer+dir)
	var layer = layers[current_layer] as LevelLayer
#	get_tree().paused = true
	NodeUtils.reparent_and_keep_transform_deferred(player, layer.viewport)
	tween.stop_all()
	tween.remove_all()
	tween.emit_signal("tween_all_completed")
	if dir > 0:
		
		layer.visible = true
		tween.interpolate_property(old_layer, "self_modulate", Color.white, Color.white.darkened(DARKEN_FACTOR), 0.5)
		tween.interpolate_property(layer, "self_modulate", Color.transparent, Color.white, 0.5)
#		tween.interpolate_property(layer, "self_modulate", layer.self_modulate, Color.white, 0.5)
		tween.interpolate_property(layers_node, "offset", Vector2.ZERO, Global.ISOMETRIC_OFFSET, 0.5)
		tween.start()
		yield(tween,"tween_all_completed")
	if dir < 0:
		var transparent = old_layer.self_modulate
		transparent.a = 0
		tween.interpolate_property(old_layer, "self_modulate", old_layer.self_modulate, transparent, 0.5)
		tween.interpolate_property(layer, "self_modulate", layer.self_modulate, Color.white, 0.5)
		tween.interpolate_property(layers_node, "offset", Vector2.ZERO, -Global.ISOMETRIC_OFFSET, 0.5)
		tween.start()
		yield(tween,"tween_all_completed")
	
#	get_tree().paused = false
	
	update_display()
	
func set_current_layer(val):
	var size = layers_node.get_children().size()
#	current_layer = Math.modulo(val, size)
	current_layer = val
