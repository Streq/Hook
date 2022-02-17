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
var aim_angle := 0.0
var shoot = false
var with_rope = false

var rope = null

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var dir : Vector2 = get_input_dir()
	
	if is_on_floor():
		if dir.x:
			velocity.x = lerp(velocity.x, dir.x*speed, run_lerp * delta)
		else:
			velocity.x = lerp(velocity.x, 0, idle_lerp * delta)
	else:
		if dir.x and abs(velocity.x) < speed:
			velocity.x = lerp(velocity.x, dir.x*speed, air_lerp * delta)
	velocity += gravity*delta
	if get_jump() and is_on_floor():
		velocity.y -= jump_speed
	
	if Input.is_action_pressed("ui_down") and is_instance_valid(rope):
		rope.queue_free()
	
	if shoot:
		shoot = false
		var arrow = ARROW.instance()
		arrow.rotation = aim_angle
		arrow.position = position
		velocity -= arrow.recoil * Vector2(cos(aim_angle),sin(aim_angle))
		get_parent().add_child(arrow)
		if with_rope:
			if is_instance_valid(rope): 
				rope.queue_free()
			arrow.connect("landed", self, "_on_arrow_with_rope_landed", [arrow])
			with_rope = false
	
	var vp = get_viewport()
	$Camera2D.position = lerp($Camera2D.position, (vp.get_mouse_position()-vp.size*0.5)/global_scale, 6*delta)
	
			
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
		
func _on_arrow_with_rope_landed(arrow):
	if is_instance_valid(rope):
		rope.queue_free()
	var rope = ROPE.instance()
	var a = Node2D.new()
	var b = Node2D.new()
	
	rope.pointA = a
	rope.pointB = b
	
	rope.length = min(500.0, (arrow.global_position - global_position).length())
	self.rope = rope

	add_child(a)
	arrow.add_child(b)
	get_parent().add_child(rope)
	
