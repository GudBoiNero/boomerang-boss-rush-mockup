extends CharacterBody2D

@export_group("Velocity Layers")
@export var momentum_velocity_layer : PlayerMomentumVelocityLayer

var _velocity_layers : Array[VelocityLayer] = []

func _ready() -> void:
	_velocity_layers.push_back(momentum_velocity_layer)

func _physics_process(delta: float) -> void:
	velocity = get_total_velocity()
	move_and_slide()

func get_total_velocity() -> Vector2:
	var vel := Vector2.ZERO

	for layer in _velocity_layers:
		vel += layer.get_output_velocity()

	return vel
