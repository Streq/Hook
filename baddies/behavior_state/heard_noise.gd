extends State

var noise_position := Vector2()
export var duration := 0.5
var timer : SceneTreeTimer
var timeout = false
#onready var anim := owner.get_node("sign_animation") as AnimationPlayer
	
func enter(args):
	#anim.play("heard_noise")
	timer = get_tree().create_timer(duration)
	timer.connect("timeout", self, "_on_timeout")
	noise_position = args[0].global_position
	timeout = false
	pass
func exit():
	#anim.play("RESET")
	pass
func update(delta:float):
	if timeout:
		emit_signal("finished", "look_at_noise", [noise_position])
func input(event):
	pass
func _on_timeout():
	timeout = true
