extends CanvasLayer
onready var level_label = $level_label

func update_level(text):
	level_label.text = text
	level_label.visible = true
	$Timer.start()

func _on_Timer_timeout():
	level_label.visible = false
