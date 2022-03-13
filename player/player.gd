extends KinematicBody2D

signal dead()
signal has_rope()
signal no_rope()

var velocity := Vector2.ZERO
export var speed := 250.0
export var jump_speed := 300.0
export var run_lerp := 6.0
export var air_lerp := 2.0
export var idle_lerp := 8.0
export var gravity := Vector2(0, 500.0)
export var team := 0
onready var input = $input

var air = false
var rope = null

const sqrt_2_inv =  1.0/sqrt(2.0)

func _physics_process(delta):
	var dir : Vector2 = get_input_dir()
	if dir.x:
		$Sprite.flip_h = dir.x < 0.0
	velocity = move_and_slide(velocity+dir*0.01, Vector2.UP)
	velocity += gravity*delta
	
	_move(dir, delta)
	if get_jump():
		_jump(dir)

func get_jump():
	return input.is_action_just_pressed("jump")

func get_input_dir() -> Vector2:
	return input.dir

func _move(dir, delta):
	if is_on_floor():
		if air:
			$step_sound.play()
			air = false
		if dir.x:
			velocity.x = lerp(velocity.x, dir.x*speed, run_lerp * delta)
			$AnimationPlayer.play("run")
		else:
			velocity.x = lerp(velocity.x, 0, idle_lerp * delta)
			$AnimationPlayer.play("idle")
	else:
		air = true
		$AnimationPlayer.play("air")


func _jump(dir):
	if is_on_floor():
		if $floor_check.get_overlapping_bodies().size()>0:
			velocity.y -= jump_speed
			$step_sound.play()
		else:
			velocity.y -= jump_speed*0.75
	elif is_on_wall() and dir.x:
		velocity.y -= jump_speed * sqrt_2_inv
		velocity.x -= dir.x*jump_speed * sqrt_2_inv
		$step_sound.play()
		
func die():
	emit_signal("dead")
	queue_free()


func _on_hurtbox_area_entered(area:Hitbox):
	if !area.is_whitelisted(self):
		die()
		
func retrieve_rope(rope):
	if is_instance_valid(rope):
		var arrow = rope.pointB.get_parent()
		arrow.hit_body = null
		rope.length = 0.0
		arrow.modulate = Color.purple
		arrow.get_node("CollisionShape2D").set_deferred("disabled", true)
		arrow.get_node("player_area").set_deferred("monitoring", true)
		arrow.get_node("terrain_area").set_deferred("monitoring", false)
