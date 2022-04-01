extends CanvasLayer
class_name LevelRoot
onready var layers_node = $layers

export (int) var current_layer := 0
export (NodePath) onready var player = get_node(player) as Player

func _ready():
	set_current_layer(current_layer)
	var layers = layers_node.get_children()
	for i in layers.size():
		var layer := layers[i] as LevelLayer
		NodeUtils.reparent(layer.camera_remote_transform, player)
	update_display()

func update_display():
	var layers = layers_node.get_children()
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
		darkness = darkness.darkened(0.2)
		layer.self_modulate = darkness
	darkness =  Color.white
	#background layers
	for i in range(current_layer-1, -1, -1):
		var layer := layers[i] as LevelLayer
		layer.visible = true
		darkness = darkness.darkened(0.2)
		layer.self_modulate = darkness
	var layer := layers[current_layer] as LevelLayer
	layer.visible = true
	layer.self_modulate = Color.white
	
func change_layer(dir):
	var layers = $layers.get_children()
	set_current_layer(current_layer+dir)
	var layer = layers[current_layer] as LevelLayer
	NodeUtils.reparent_and_keep_transform_deferred(player, layer.viewport)
	update_display()

func set_current_layer(val):
	var size = layers_node.get_children().size()
	current_layer = Math.modulo(val, size)
