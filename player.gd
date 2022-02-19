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
var aim_angle := 0.0
var shoot = false
var with_rope = false


var rope = null

const sqrt_2_inv =  1.0/sqrt(2.0)

func _physics_process(delta):
	
	var dir : Vector2 = get_input_dir()
	velocity = move_and_slide(velocity+dir, Vector2.UP)
	
	if is_on_floor():
		if dir.x:
			velocity.x = lerp(velocity.x, dir.x*speed, run_lerp * delta)
		else:
			velocity.x = lerp(velocity.x, 0, idle_lerp * delta)
#	else:
#		if dir.x and abs(velocity.x) < speed:
#			velocity.x = lerp(velocity.x, dir.x*speed, air_lerp * delta)
	velocity += gravity*delta
	if get_jump():
		if is_on_floor():
			velocity.y -= jump_speed
		elif is_on_wall() and dir.x:
			velocity.y -= jump_speed * sqrt_2_inv
			velocity.x -= dir.x*jump_speed * sqrt_2_inv
	if Input.is_action_just_released("shoot_hook") and is_instance_valid(rope):
		var arrow = rope.pointB.get_parent()
		arrow.hit_body = null
		rope.length = 0.0
		arrow.modulate = Color.purple
		arrow.get_node("player_area").set_deferred("monitoring", true)
		arrow.get_node("terrain_area").set_deferred("monitoring", false)
		
	
	if shoot and !is_instance_valid(rope):
		var arrow = ARROW.instance()
		arrow.rotation = aim_angle
		arrow.position = position
		arrow.velocity += velocity
		velocity -= arrow.recoil * Vector2(cos(aim_angle),sin(aim_angle))
		get_parent().add_child(arrow)
		if with_rope:
			add_rope_to_arrow(arrow)
			arrow.connect("landed", self, "_on_arrow_with_rope_landed", [arrow, rope])
			arrow.connect("returned", self, "_on_arrow_with_rope_returned", [arrow, rope])
			with_rope = false
	shoot = false
		
	var vp = get_viewport()
	$Camera2D.position = lerp($Camera2D.position, (vp.get_mouse_position()-vp.size*0.5)/global_scale, 6*delta)
	
	if is_instance_valid(rope) and is_instance_valid(rope.pointB.get_parent().hit_body):
		if Input.is_action_pressed("reel_in"):
			rope.length = max(0, rope.length-300*delta)
		if Input.is_action_pressed("reel_out"):
			rope.length = min(max_rope_length, rope.length+300*delta)
		if Input.is_action_pressed("insta_reel"):
			rope.length = 0
func get_jump():
	return Input.is_action_just_pressed("ui_up")

func get_input_dir() -> Vector2:
	return Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)
	
func _input(event):
	var shoot_hook = event.is_action_pressed("shoot_hook")
	if shoot_hook:
		with_rope = true
	if shoot_hook or event.is_action_pressed("shoot_arrow"):
		var e : InputEventMouseButton = event
		var mouse_viewport_position := e.position
		var player_viewport_position := get_global_transform_with_canvas().origin
		aim_angle = (mouse_viewport_position-player_viewport_position).angle()
		shoot = true
		
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
