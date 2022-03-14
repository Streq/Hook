extends Control


func _ready():
	for id in Levels.levels.size():
		var button = Button.new()
		var level = Levels.levels[id] as LevelDefinition
		button.text = str(id) + ". " + level.title
		button.align = Button.ALIGN_LEFT
		button.rect_min_size.x = 200

		button.disabled = Levels.highest_available < id
		add_child(button)
		button.connect("pressed", Levels, "to_level", [id])
		button.hint_tooltip = level.description
		
