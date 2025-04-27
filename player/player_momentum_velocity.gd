extends Velocity
class_name PlayerMomentumVelocity

@export var WALK_SPEED := 6_000.0
@export var RUN_SPEED := 10_000.0
@export var SPRINT_SPEED := 16_000.0

@export var WALK_TO_RUN_TRANSITION := 0.9
@export_range(0, 1, 0.01) var ACCEL_TIME := 0.05  # Acceleration smoothing
@export_range(0, 1, 0.01) var DECEL_TIME := 0.1  # Deceleration smoothing (friction)

var _speed := WALK_SPEED
var _target_speed := 0.0

enum SpeedStates { WALK, RUN, SPRINT }
var speed_state : SpeedStates = SpeedStates.WALK

func _velocity_physics_process(delta: float) -> void:
	var input := PlayerInputService.get_move_input()
	print(input)

	update_speed_state(delta)
	update_velocity(input, delta)

func update_speed_state(delta: float) -> void:
	var speed_threshold := WALK_SPEED * delta * WALK_TO_RUN_TRANSITION
	var current_speed := _velocity.length()

	match speed_state:
		SpeedStates.WALK:
			if current_speed >= speed_threshold:
				speed_state = SpeedStates.RUN
			_speed = WALK_SPEED

		SpeedStates.RUN:
			if current_speed <= speed_threshold:
				speed_state = SpeedStates.WALK
			_speed = RUN_SPEED

		SpeedStates.SPRINT:
			_speed = SPRINT_SPEED

func update_velocity(input: Vector2, delta: float) -> void:
	var max_frame_velocity := _speed * delta
	_velocity.limit_length(max_frame_velocity)

	var target_velocity := _speed * input * delta

	var smoothing := ACCEL_TIME if input.length() > 0.01 else DECEL_TIME
	var target := target_velocity if input.length() > 0.01 else Vector2.ZERO

	_velocity = _velocity.lerp(target, delta / smoothing)

	# Hard stop for tiny velocity values
	if _velocity.length() < 1.0:
		_velocity = Vector2.ZERO
