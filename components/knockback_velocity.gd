extends Velocity
class_name KnockbackVelocity

signal kb_finished(context: HitBoxContext)

var _context : HitBoxContext = null

func use(context: HitBoxContext) -> void:
	if context:
		_context = context
		_velocity = _context.get_kb() * get_physics_process_delta_time()

func _velocity_stop() -> void:
	_context = null

func _velocity_physics_process(delta: float) -> void:
	if _context:
		var decay := delta / _context.kb_duration
		_velocity = _velocity.lerp(Vector2.ZERO, decay)
	if _velocity.abs() < Vector2.ONE:
		kb_finished.emit(_context.duplicate())
