extends Node2D
tool
export (String, MULTILINE) onready var text setget set_text

func set_text(val):
	text = val
	$Label.text = val
