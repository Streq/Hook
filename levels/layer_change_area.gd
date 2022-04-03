extends Area2D
export var direction := 1
onready var prompt := $prompt
onready var tiles := $tiles
var body = null
func _on_body_entered(body:PhysicsBody2D):
#	print(body.name, " entered ", name)
	if !body.is_connected("interact", self, "change_layer"):
		body.connect("interact", self, "change_layer")
	prompt.visible = true
	prompt.global_position = body.global_position
	self.body = body
		
func _on_body_exited(body:PhysicsBody2D):
#	print(body.name, " exited ", name)
	if body.is_connected("interact", self, "change_layer"):
		body.disconnect("interact", self, "change_layer")
	prompt.visible = false
	self.body = null
	
func change_layer():
	var root = get_tree().get_nodes_in_group("level_root")[0]
	root.change_layer(direction)

func _physics_process(delta):
	if is_instance_valid(body):
		prompt.global_position = body.global_position

func _ready():
	tiles.visible = direction>0
	prompt.visible = false
