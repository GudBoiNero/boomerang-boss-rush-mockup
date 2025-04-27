extends Velocity
class_name KnockbackVelocity

signal kb_finished(context: HitBoxContext)

var context : HitBoxContext = null

func _enabled() -> void:
	if context:
		_velocity = context.get_kb() * get_physics_process_delta_time()

func _disabled() -> void:
	context = null

func _velocity_physics_process(delta: float) -> void:
	if context:
		var decay := delta / context.kb_duration
		_velocity = _velocity.lerp(Vector2.ZERO, decay)
	if _velocity.abs() < Vector2.ONE:
		kb_finished.emit(context.duplicate())
