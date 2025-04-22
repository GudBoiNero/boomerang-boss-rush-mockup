extends CharacterBody2D
class_name PlayerController

@export_group("Velocity Layers")
@export var momentum_velocity_layer : PlayerMomentumVelocityLayer

@export_group("Boomerang")
@export var br_distance_curve: CurveTexture
@export var br_charge_time := 0.9
@export var br_max_distance := 300.0

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
