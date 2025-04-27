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
	print(_stun, is_stunned())
	if !is_stunned():
		v_momentum.start()
	if v_kb.is_finished() and !is_stunned():
		state_machine.set_state(s_free)

func _is_data_valid(value: Variant) -> bool:
	return value is HitBoxContext

func _state_entered(from: State) -> void:
	var incoming_data : HitBoxContext = data as HitBoxContext
	_stun = data.kb_stun

	if is_stunned():
		v_momentum.stop()
	v_kb.use(data)
	v_kb.start()

func _state_exited(to: State) -> void:
	_stun = 0.0

func is_stunned() -> bool:
	return _stun > 0.0
