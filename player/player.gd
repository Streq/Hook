extends KinematicBody2D
class_name Player
signal dead()
signal has_rope()
signal no_rope()
signal interact()


var velocity := Vector2.ZERO
export var speed := 250.0
export var jump_speed := 300.0
export var run_lerp := 6.0
export var air_lerp := 2.0
export var idle_lerp := 8.0
export var gravity := Vector2(0, 500.0)
export var team := 0
onready var input = $input
onready var sprite := $Sprite
onready var animation : AnimationPlayer = $AnimationPlayer
onready var floor_check := $floor_check
onready var shooter := $shooter
onready var controller := $controller
export (float, -360, 360) var look_rotation_degrees := 0.0


var background_room_hole = []
var air = false
var rope = null
var facing_dir := 1.0 setget set_facing_dir
var can_interact = true

const sqrt_2_inv =  1.0/sqrt(2.0)

func _ready():
	if "rotation_degrees" in controller:
		controller.rotation_degrees = look_rotation_degrees

func _physics_process(delta):
	if can_interact and input.is_action_just_pressed("reel_out"):
		emit_signal("interact")
	pass

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
			animation.play("run")
		else:
			velocity.x = lerp(velocity.x, 0, idle_lerp * delta)
			animation.play("idle")
	else:
		air = true
		animation.play("air")

func feet_on_the_ground():
	return floor_check.get_overlapping_bodies().size()>0

func _jump(dir):
	if is_on_floor():
		if feet_on_the_ground():
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

func set_facing_dir(dir):
	var s = sign(dir)
	if s:
		facing_dir = s
		sprite.flip_h = s < 0
		
