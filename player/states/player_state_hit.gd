extends State
class_name PlayerStateHit

@onready var state_machine : StateMachine = %StateMachine
@onready var s_free : PlayerStateFree = %Free

@onready var v_momentum : PlayerMomentumVelocity = %Momentum
@onready var v_kb : KnockbackVelocity = %Knockback

## Stun timer
var _stun : float = 0.0

func _state_physics_process(delta: float) -> void:
	_stun = max(0, _stun - delta)
	if !is_stunned():
		v_momentum.steal(v_kb)
		v_momentum.start()
		state_machine.set_state(s_free)
	elif v_kb.is_finished():
		state_machine.set_state(s_free)

func _is_data_valid(value: Variant) -> bool:
	return value is HitBoxContext

func _state_entered(from: State) -> void:
	var incoming_data : HitBoxContext = _data as HitBoxContext
	_stun = _data.kb_stun

	if is_stunned():
		v_momentum.stop()
	v_kb.use(_data)
	v_kb.start()

func _state_exited(to: State) -> void:
	_stun = 0.0
	clear_data()

func is_stunned() -> bool:
	return _stun > 0.0
