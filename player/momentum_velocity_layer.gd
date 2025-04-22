extends VelocityLayer
class_name PlayerMomentumVelocityLayer

@export var SPEED := 4000.0

func _velocity_physics_process(delta: float) -> void:
	var input := PlayerInputService.get_input_raw()
	print(input)
	_velocity = input * delta * SPEED
