extends State
class_name PlayerStateFree

@onready var v_momentum: PlayerMomentumVelocity = %Momentum
@onready var v_kb: KnockbackVelocity = %Knockback

func _ready() -> void:
	state_entered.connect(enter)

func enter(from: State) -> void:
	v_momentum.start()
	v_kb.stop()
