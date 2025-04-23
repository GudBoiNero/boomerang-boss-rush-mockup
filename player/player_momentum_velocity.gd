extends Velocity
class_name PlayerMomentumVelocity

@export var WALK_SPEED := 6_000.0
@export var RUN_SPEED := 10_000.0
@export var SPRINT_SPEED := 16_000.0

var _target_speed := 0.0
var _speed := WALK_SPEED

func _velocity_physics_process(delta: float) -> void:
	var input := PlayerInputService.get_input_raw()
	PlayerInputService.get_aim()
	_velocity = lerp(_velocity, input * delta * WALK_SPEED, 0.02)
