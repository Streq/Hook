extends Node

export (Array, Resource) var levels : Array


var current_level = 0

func next_level():
	to_level(current_level + 1)


func to_level(id):
	current_level = id
	var level = levels[current_level] as LevelDefinition
	get_tree().change_scene_to(level.map)
	
