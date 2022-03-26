extends Node2D
tool
export (String) onready var text := "label" setget set_text

func set_text(val):
	text = val
	$Label.text = val
