extends Node2D

signal ledge_entered()
signal ledge_exited()

var gap := false
var wall := false
var ledge := false
func check_ledge():
	if gap and wall and !ledge:
		emit_signal("ledge_entered")
		ledge = true
	elif (!gap or !wall) and ledge:
		emit_signal("ledge_exited")
		ledge = false
		
func _on_gap_check_body_exited(body):
	gap = true
	check_ledge()

func _on_gap_check_body_entered(body):
	gap = false
	check_ledge()

func _on_wall_check_body_exited(body):
	wall = false
	check_ledge()

func _on_wall_check_body_entered(body):
	wall = true
	check_ledge()
