extends Velocity
class_name PlayerMomentumVelocity

@export var WALK_SPEED := 6_000.0
@export var RUN_SPEED := 10_000.0
@export var SPRINT_SPEED := 16_000.0

@export var WALK_TO_RUN_TRANSITION := 0.9

@export var ACCEL_TIME : float = 0.1  # Acceleration time
@export var DECEL_TIME : float = 0.2   # Deceleration (friction) time

var _target_speed := 0.0
var _speed := WALK_SPEED

enum SpeedStates {
	WALK, RUN, SPRINT
}

var speed_state : SpeedStates = SpeedStates.WALK

func _velocity_physics_process(delta: float) -> void:
	var input := PlayerInputService.get_input()
	PlayerInputService.get_aim()

	# Determine max velocity for this frame
	var max_velocity := _speed * delta
	_velocity.limit_length(max_velocity)

	# Handle speed state transitions
	match speed_state:
		SpeedStates.WALK:
			var run_threshold := WALK_SPEED * delta * WALK_TO_RUN_TRANSITION
			if _velocity.length() >= run_threshold or is_equal_approx(_velocity.length(), run_threshold):
				speed_state = SpeedStates.RUN
			_speed = WALK_SPEED

		SpeedStates.RUN:
			var walk_threshold := WALK_SPEED * delta * WALK_TO_RUN_TRANSITION
			if _velocity.length() <= walk_threshold or is_equal_approx(_velocity.length(), walk_threshold):
				speed_state = SpeedStates.WALK
			_speed = RUN_SPEED

		SpeedStates.SPRINT:
			_speed = SPRINT_SPEED

	# Compute target velocity from input and current speed
	var target_velocity := _speed * input * delta

	# Use different smoothing for accel vs decel
	if input.length() > 0.01:
		_velocity = _velocity.lerp(target_velocity, delta / ACCEL_TIME)
	else:
		_velocity = _velocity.lerp(Vector2.ZERO, delta / DECEL_TIME)

	# Optional: hard stop if nearly zero
	if _velocity.length() < 1.0:
		_velocity = Vector2.ZERO
