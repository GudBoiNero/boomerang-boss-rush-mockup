extends CharacterBody2D
class_name PlayerController

@export_group("Boomerang")
@export var br_distance_curve: CurveTexture
@export var br_charge_time := 0.9
@export var br_max_distance := 300.0

@onready var velocity_controller: VelocityController = %VelocityController
@onready var momentum_velocity_layer: PlayerMomentumVelocity = %Momentum


func _physics_process(delta: float) -> void:
	velocity = velocity_controller.get_velocity()
	if move_and_slide():
		velocity_controller.on_collision.emit(get_slide_collision(get_slide_collision_count() - 1))
