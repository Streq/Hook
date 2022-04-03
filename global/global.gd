extends Node
signal zoom_changed()
#offset between two layers so that it looks like 
#terrain in one is right behind terrain in the other
const ISOMETRIC_OFFSET := Vector2(14.0, -6.0)


const SAVE_PATH = "user://savegame.save"

var zoom = Vector2(1,1)



func _ready():
	load_game()

func save_game():
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	save_game.store_line(to_json({"level":Levels.highest_available}))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return # Error! We don't have a save to load.

	save_game.open(SAVE_PATH, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		Levels.highest_available = max(node_data["level"], Levels.highest_available)
		
	save_game.close()


func restart():
	get_tree().reload_current_scene()


func _input(event):
	if event.is_action_pressed("ui_end"):
		restart()
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action("zoom_in"):
		zoom = Vector2(1,1)
		emit_signal("zoom_changed")
	elif event.is_action("zoom_out"):
		zoom = Vector2(2,2)
		emit_signal("zoom_changed")
