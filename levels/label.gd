extends Node2D
tool
enum Align {
	ALIGN_LEFT = 0,
	ALIGN_CENTER = 1,
	ALIGN_RIGHT = 2,
	ALIGN_FILL = 3
}
enum VAlign {
	VALIGN_TOP = 0,
	VALIGN_CENTER = 1,
	VALIGN_BOTTOM = 2,
	VALIGN_FILL = 3
}
export (String, MULTILINE) onready var text setget set_text
export (Align) var align setget set_align
export (VAlign) var valign setget set_valign

func set_text(val):
	text = val
	$Label.text = val
func set_align(val):
	align = val
	$Label.align = val
func set_valign(val):
	valign = val
	$Label.valign = val
