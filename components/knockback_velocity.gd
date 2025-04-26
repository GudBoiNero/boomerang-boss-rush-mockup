extends Velocity
class_name KnockbackVelocity

var context : HitBoxContext = null

func _enabled() -> void:
	if context:
		_velocity = context.get_kb() * get_physics_process_delta_time()

func _velocity_physics_process(delta: float) -> void:
	if context:
		print(_velocity)
		var decay := delta / context.kb_duration
		_velocity = _velocity.lerp(Vector2.ZERO, decay)
