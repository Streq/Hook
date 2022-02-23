extends Node2D
signal trigger()

export var count := 1

export var goal_count := 0

func decrease_counter():
	count -= 1
	if count == goal_count:
		emit_signal("trigger")

func increase_counter():
	count += 1
	if count == goal_count:
		emit_signal("trigger")
