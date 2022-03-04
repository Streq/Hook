extends Node2D


export var ARROW : PackedScene

export var team := 0
onready var input = $input

var shoot := false
var aim_angle := 0.0
var velocity := Vector2.ZERO

func _physics_process(delta):
	#shoot logic
	if input.is_action_just_pressed("shoot_arrow"):
		shoot = true
		aim_angle = input.aim_angle
	
	if shoot:
		var arrow = ARROW.instance()
		arrow.init(self, aim_angle)
		get_parent().add_child(arrow)
	shoot = false
		
	
