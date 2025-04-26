extends State
class_name PlayerStateHit

@onready var v_momentum : PlayerMomentumVelocity = %Momentum
@onready var v_kb : KnockbackVelocity = %Knockback

func _is_data_valid(value: Variant) -> bool:
	return value is HitBoxContext or value == null

func _state_entered(from: State) -> void:
	v_momentum.enabled = false
	v_kb.context = data
	v_kb.enabled = true
