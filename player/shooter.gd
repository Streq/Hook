extends Node2D

export (NodePath) onready var input = get_node(input) as InputState
export (NodePath) onready var rope_point = get_node(rope_point) as Node2D
export var ARROW : PackedScene
export var HOOK_ARROW : PackedScene
export var ROPE : PackedScene

export var reel_speed = 100.0
export var max_rope_length := 250.0

var shoot := false
var with_rope := false
var aim_angle := 0.0
var rope = null
var swing_distance = 10.0

func retrieve_rope(rope):
	if is_instance_valid(rope):
		var arrow = rope.pointB.get_parent()
		arrow.hit_body = null
		rope.length = 0.0
		arrow.modulate = Color.purple
		arrow.get_node("CollisionShape2D").set_deferred("disabled", true)
		arrow.get_node("player_area").set_deferred("monitoring", true)
		arrow.get_node("terrain_area").set_deferred("monitoring", false)

func _physics_process(delta):
	#shoot logic
	var dir : Vector2 = input.dir
	var shoot_hook = input.is_action_just_pressed("shoot_hook")
	with_rope = shoot_hook
	if shoot_hook or input.is_action_just_pressed("shoot_arrow"):
		shoot = true
		aim_angle = input.aim_angle

	
	if is_instance_valid(rope):
		rope_point.position = (rope.pointB.global_position - rope.pointA.global_position).tangent().normalized()*dir.x*swing_distance
		
		if input.is_action_just_released("shoot_hook"):
			retrieve_rope(rope)
	elif shoot:
		var arrow : Arrow = ARROW.instance() if !shoot_hook else HOOK_ARROW.instance()
		var shooter = get_parent()
		arrow.init(shooter, aim_angle)
		
		shooter.get_parent().add_child(arrow)
		if with_rope:
			add_rope_to_arrow(arrow)
			arrow.connect("landed", self, "_on_arrow_with_rope_landed", [arrow, rope])
			arrow.connect("returned", self, "_on_arrow_with_rope_returned", [arrow, rope])
			arrow.connect("bounced", self, "_on_arrow_with_rope_bounced", [arrow, rope])
			arrow.get_node("hitbox").set_deferred("monitorable", false)
			arrow.get_node("hitbox").set_deferred("monitoring", false)
			with_rope = false
	shoot = false
		
	
	if is_instance_valid(rope):
		if is_instance_valid(rope.pointB):
			if is_instance_valid(rope.pointB.get_parent().hit_body):
				if input.is_action_pressed("reel_in"):
					rope.length = max(0, rope.length-reel_speed*delta)
				if input.is_action_pressed("reel_out"):
					rope.length = min(max_rope_length, rope.length+reel_speed*3*delta)
				if input.is_action_pressed("insta_reel"):
					rope.length = 0
		else: 
			rope.queue_free()
func add_rope_to_arrow(arrow):
	if is_instance_valid(rope):
		rope.queue_free()
	var rope = ROPE.instance()
	var a = rope_point
	var b = Node2D.new()
	
	rope.pointA = a
	rope.pointB = b
	
	rope.length = max_rope_length
	self.rope = rope

	arrow.add_child(b)
	get_parent().add_child(rope)

func _on_arrow_with_rope_landed(arrow, rope):
	if is_instance_valid(rope) and input.is_action_pressed("shoot_hook"):
		rope.length = min(max_rope_length, to_local(arrow.global_position).length())
		pass
		
func _on_arrow_with_rope_returned(arrow, rope):
	if is_instance_valid(rope):
		rope.queue_free()
	if is_instance_valid(arrow):
		arrow.queue_free()

func _on_arrow_with_rope_bounced(arrow, rope):
	retrieve_rope(rope)
