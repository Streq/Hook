extends KinematicBody2D

export var ARROW : PackedScene
export var ROPE : PackedScene

var velocity := Vector2.ZERO
export var speed := 500.0
export var jump_speed := 600.0
export var run_lerp := 6.0
export var air_lerp := 2.0
export var idle_lerp := 8.0
export var gravity := Vector2(0, 1000.0)
export var max_rope_length := 500.0

onready var input = $input

var shoot := false
var with_rope := false
var aim_angle := 0.0

var rope = null

const sqrt_2_inv =  1.0/sqrt(2.0)

func _physics_process(delta):
	
	var dir : Vector2 = get_input_dir()
	velocity = move_and_slide(velocity+dir, Vector2.UP)
	velocity += gravity*delta
	
	_move(dir, delta)
	if get_jump():
		_jump(dir)

	var shoot_hook = input.is_action_just_pressed("shoot_hook")
	if shoot_hook:
		with_rope = true
	if shoot_hook or input.is_action_just_pressed("shoot_arrow"):
		shoot = true
		aim_angle = input.aim_angle

	if input.is_action_just_released("shoot_hook") and is_instance_valid(rope):
		var arrow = rope.pointB.get_parent()
		arrow.hit_body = null
		rope.length = 0.0
		arrow.modulate = Color.purple
		arrow.get_node("player_area").set_deferred("monitoring", true)
		arrow.get_node("terrain_area").set_deferred("monitoring", false)
		
	
	if shoot and !is_instance_valid(rope):
		var arrow = ARROW.instance()
		arrow.caster = self
		arrow.rotation = aim_angle
		arrow.position = position
		arrow.velocity += velocity
		velocity -= arrow.recoil * Vector2(cos(aim_angle),sin(aim_angle))
		get_parent().add_child(arrow)
		if with_rope:
			add_rope_to_arrow(arrow)
			arrow.connect("landed", self, "_on_arrow_with_rope_landed", [arrow, rope])
			arrow.connect("returned", self, "_on_arrow_with_rope_returned", [arrow, rope])
			arrow.get_node("hitbox").set_deferred("monitoring", false)
			arrow.get_node("hitbox").set_deferred("monitorable", false)
			with_rope = false
	shoot = false
		
	
	if is_instance_valid(rope) and is_instance_valid(rope.pointB.get_parent().hit_body):
		if input.is_action_pressed("reel_in"):
			rope.length = max(0, rope.length-300*delta)
		if input.is_action_pressed("reel_out"):
			rope.length = min(max_rope_length, rope.length+300*delta)
		if input.is_action_pressed("insta_reel"):
			rope.length = 0
func get_jump():
	return input.is_action_just_pressed("jump")

func get_input_dir() -> Vector2:
	return input.dir


func add_rope_to_arrow(arrow):
	if is_instance_valid(rope):
		rope.queue_free()
	var rope = ROPE.instance()
	var a = Node2D.new()
	var b = Node2D.new()
	
	rope.pointA = a
	rope.pointB = b
	
	rope.length = max_rope_length
	self.rope = rope

	add_child(a)
	arrow.add_child(b)
	get_parent().add_child(rope)

func _on_arrow_with_rope_landed(arrow, rope):
	if is_instance_valid(rope):
		rope.length = min(max_rope_length, to_local(arrow.global_position).length())
		pass
		
func _on_arrow_with_rope_returned(arrow, rope):
	if is_instance_valid(rope):
		rope.queue_free()
	if is_instance_valid(arrow):
		arrow.queue_free()
		
func _move(dir, delta):
	if is_on_floor():
		if dir.x:
			velocity.x = lerp(velocity.x, dir.x*speed, run_lerp * delta)
		else:
			velocity.x = lerp(velocity.x, 0, idle_lerp * delta)

func _jump(dir):
	if is_on_floor():
		velocity.y -= jump_speed
	elif is_on_wall() and dir.x:
		velocity.y -= jump_speed * sqrt_2_inv
		velocity.x -= dir.x*jump_speed * sqrt_2_inv
