extends CanvasLayer

export var current_layer := 2
export (NodePath) onready var player = get_node(player) as Player

func _ready():
	var layers = $layers.get_children()
	for i in layers.size():
		var layer := layers[i] as LevelLayer
		NodeUtils.reparent(layer.camera_remote_transform, player)
	update_display()

func update_display():
	var layers = $layers.get_children()
	var darkness = Color.white
	for i in range (layers.size()-1, -1, -1):
		var layer := layers[i] as LevelLayer
		layer.viewport.audio_listener_enable_2d = true
		if i <= current_layer:
			layer.visible = true
			layer.self_modulate = darkness
			darkness = darkness.darkened(0.2)
		else:
			layer.visible = false
		layer.camera.position = (current_layer+i)*Global.ISOMETRIC_OFFSET
		layer.camera_remote_transform.remote_path = layer.camera_pivot.get_path()
func change_layer():
	var layers = $layers.get_children()
	current_layer = (current_layer + layers.size() + 1) % layers.size()
	var layer = layers[current_layer] as LevelLayer
	NodeUtils.reparent_and_keep_transform_deferred(player, layer.viewport)
	update_display()


