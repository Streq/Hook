extends Area2D


func _on_shieldbox_area_entered(area):
	if area.owner.caster != owner:
		area.owner.queue_free()
