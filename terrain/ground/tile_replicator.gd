extends Node2D


func _ready():
	var original := get_parent() as TileMap
	var tile_data = original.get("tile_data")
	for child in get_children():
		var c = child as TileMap
		c.self_modulate = original.self_modulate
		c.set("tile_data", tile_data)
		c.update_bitmask_region()
	#hide original
	original.self_modulate.a = 0
	#force self_modulate update
	original.set("tile_data", tile_data)
