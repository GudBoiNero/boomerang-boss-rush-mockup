extends CharacterBody2D
class_name PlayerController

@export_group("Boomerang")
@export var br_distance_curve: CurveTexture
@export var br_charge_time := 0.9
@export var br_max_distance := 300.0

@onready var health_component : HealthComponent = %HealthComponent
@onready var hurtbox : HurtBox = %HurtBox

@onready var state_machine: StateMachine = %StateMachine
@onready var s_free : PlayerStateFree = %Free
@onready var s_hit : PlayerStateHit = %Hit

@onready var velocity_controller: VelocityController = %VelocityController
@onready var v_momentum: PlayerMomentumVelocity = %Momentum
@onready var v_knockback: KnockbackVelocity = %Knockback

func _ready() -> void:
	health_component.health_depleted.connect(_death)
	hurtbox.hitbox_entered.connect(_hit)


#region process
func _death(context: HitBoxContext) -> void:
	get_tree().reload_current_scene.call_deferred()


func _hit(context: HitBoxContext) -> void:
	state_machine.set_state(s_hit, context)


func _physics_process(delta: float) -> void:
	var target := velocity_controller.get_velocity()
	velocity = target
	if move_and_slide():
		velocity_controller.on_move_and_slide.emit(target, get_slide_collision(0))
	else:
		velocity_controller.on_move_and_slide.emit(target, null)
#endregion
