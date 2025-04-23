extends CharacterBody2D
class_name PlayerController

@export_group("Boomerang")
@export var br_distance_curve: CurveTexture
@export var br_charge_time := 0.9
@export var br_max_distance := 300.0

@onready var velocity_controller: VelocityLayerController = %VelocityLayerController
@onready var momentum_velocity_layer: PlayerMomentumVelocityLayer = %MomentumVelocityLayer


func _physics_process(delta: float) -> void:
	velocity = velocity_controller.get_velocity()
	move_and_slide()
