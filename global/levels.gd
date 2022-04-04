extends Node

export (Array, Resource) var levels : Array
export (PackedScene) var level_select
export (PackedScene) var win_screen
export (String, DIR) var ssasa
var current_level = 0
var highest_available = 0
var won = false
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
	elif !won:
		level = win_screen 
		won = true
	else:
		level = level_select
		won = false
	get_tree().change_scene_to(level)
