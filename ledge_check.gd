extends Node2D

signal ledge_entered()
signal ledge_exited()


onready var gap_check := $gap_check
onready var wall_check := $wall_check

var ledge := false
var just_changed = false
	

func _physics_process(delta):
	if just_changed:
		just_changed = false
	else:
		var gap = gap_check.get_overlapping_bodies().size() == 0
		var wall = wall_check.get_overlapping_bodies().size() > 0
		if gap and wall and !ledge:
			emit_signal("ledge_entered")
			ledge = true
			just_changed = true
		elif (!gap or !wall) and ledge:
			emit_signal("ledge_exited")
			ledge = false
			just_changed = true

