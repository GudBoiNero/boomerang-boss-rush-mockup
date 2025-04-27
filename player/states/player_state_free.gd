extends State
class_name PlayerStateFree

@onready var v_momentum: PlayerMomentumVelocity = %Momentum
@onready var v_kb: KnockbackVelocity = %Knockback

func _ready() -> void:
	state_entered.connect(enter)

func _state_physics_process(delta: float) -> void:
	print(v_momentum.get_velocity(), " : ", v_kb.get_velocity())

func enter(from: State) -> void:
	v_momentum.start()
	v_kb.stop()
