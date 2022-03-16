extends Hurtbox
class_name ShieldBox

export (NodePath) onready var _owner = get_node(_owner) if _owner else owner

func _ready():
	owner = _owner


func _on_shieldbox_area_entered(area:Hitbox):
	if area.owner is Arrow and area.owner.caster != owner:
		var arrow := area.owner as Arrow
		arrow.velocity = arrow.velocity.bounce(Vector2.RIGHT.rotated(global_rotation))*0.6
		arrow.emit_signal("bounced")
