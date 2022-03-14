extends Node

export (Array, Resource) var levels : Array
export (PackedScene) var level_select

var current_level = 0
var highest_available = 0

func next_level():
	highest_available = max(current_level + 1, highest_available)
	to_level(current_level + 1)


func to_level(id):
	current_level = id
	var level
	if levels.size() > id:
		level = levels[current_level].map
	else:
		level = level_select 
	
	get_tree().change_scene_to(level)
