@icon("res://textures/icon/hitbox_context.svg")
extends Resource
class_name HitBoxContext

@export var damage : int = 1
@export_group("Knockback")
@export var does_kb : bool = false
@export var kb_duration : float = 0.2
## force of knockback
@export var kb_force : float = 1000.0
## TODO: Implement
@export var kb_type : KnockbackTypes = KnockbackTypes.OUTWARDS
## Overrides get_kb_direction if non zero value
@export var kb_direction : Vector2 = Vector2.ZERO

var source : HitBox
var hurtbox : HurtBox
var position : Vector2

enum KnockbackTypes {
	## DIRECTIONAL: kb_direction
	DIRECTIONAL,
	## OUTWARDS: from center of hitbox towards hurtbox hit
	OUTWARDS
}

func get_kb() -> Vector2:
	if kb_type == KnockbackTypes.DIRECTIONAL:
		return kb_direction * kb_force
	else:
		var dir := position.direction_to(hurtbox.global_position)
		return dir * kb_force
