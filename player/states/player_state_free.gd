extends State
class_name PlayerStateFree

@onready var v_momentum: PlayerMomentumVelocity = %Momentum

func _ready() -> void:
	state_entered.connect(enter)

func enter(from: State) -> void:
	v_momentum.enabled = true
	
