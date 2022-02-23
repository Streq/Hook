extends Node

export (Array, PackedScene) var levels

var current_level = 0

func next_level():
	current_level += 1
	get_tree().change_scene_to(levels[current_level])
