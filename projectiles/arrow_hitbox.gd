extends Hitbox

func is_whitelisted(body)->bool:
	var arrow := owner as Arrow
	return body == arrow.caster and !arrow.hurt_caster
