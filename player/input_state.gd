extends Node
class_name InputState

var dir := Vector2.ZERO
var aim_angle := 0.0
var buttons = {
	"jump" : InputButton.new(),
	"reel_in" : InputButton.new(),
	"reel_out" : InputButton.new(),
	"insta_reel" : InputButton.new(),
	"shoot_arrow" : InputButton.new(),
	"shoot_hook" : InputButton.new(),
}
func _ready():
	get_tree().connect("idle_frame", self, "_clear_just_updated")

func _clear_just_updated():
	for button in buttons.values():
		button.just_updated = false

func is_action_just_pressed(action):
	var button = buttons[action]
	return button.pressed and button.just_updated

func is_action_just_released(action):
	var button = buttons[action]
	return !button.pressed and button.just_updated

func is_action_pressed(action):
	var button = buttons[action]
	return button.pressed

func set_action_pressed(action, pressed):
	buttons[action].pressed = pressed

func has_action(action):
	return buttons.has(action)

func get_actions():
	return buttons.keys()

class InputButton:
	var pressed := false setget set_pressed
	var just_updated := false
	func set_pressed(val):
		just_updated = (pressed != val)
		pressed = val
		

