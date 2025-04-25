extends CharacterBody2D
class_name PlayerController

@export_group("Boomerang")
@export var br_distance_curve: CurveTexture
@export var br_charge_time := 0.9
@export var br_max_distance := 300.0

@onready var state_machine: StateMachine = %StateMachine
@onready var s_free : PlayerStateFree = %Free
@onready var s_hit : State = %Hit

@onready var velocity_controller: VelocityController = %VelocityController
@onready var v_momentum: PlayerMomentumVelocity = %Momentum

#region process
func _death(hitbox: HitBox) -> void:
	get_tree().reload_current_scene.call_deferred()


func _hit(hitbox: HitBox) -> void:
	state_machine.set_state(s_hit)

func _physics_process(delta: float) -> void:
	var target := velocity_controller.get_velocity()
	velocity = target
	if move_and_slide():
		velocity_controller.on_move_and_slide.emit(target, get_slide_collision(0))
	else:
		velocity_controller.on_move_and_slide.emit(target, null)
#endregion
