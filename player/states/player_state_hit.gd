extends State
class_name PlayerStateHit

@onready var state_machine : StateMachine = %StateMachine
@onready var s_free : PlayerStateFree = %Free

@onready var v_momentum : PlayerMomentumVelocity = %Momentum
@onready var v_kb : KnockbackVelocity = %Knockback

func _is_data_valid(value: Variant) -> bool:
	return value is HitBoxContext or value == null

func _state_entered(from: State) -> void:
	var _data : Variant = data
	v_momentum.stop()
	v_kb.context = data
	v_kb.start()
	await v_kb.kb_finished
	if _data == data:
		state_machine.set_state(s_free)
