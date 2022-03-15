extends Node

export (Array, Resource) var levels : Array
export (PackedScene) var level_select
export (String, DIR) var ssasa
var current_level = 0
var highest_available = 0

func next_level():
	var next = current_level + 1
	if highest_available < next:
		highest_available = next
		Global.save_game()
	to_level(next)


func to_level(id):
	current_level = id
	var level
	if levels.size() > id:
		level = levels[current_level].map
	else:
		level = level_select 
	
	get_tree().change_scene_to(level)
