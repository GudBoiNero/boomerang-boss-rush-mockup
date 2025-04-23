extends State

@onready var momentum_layer: PlayerMomentumVelocity = %Momentum

func _ready() -> void:
	state_entered.connect(enter)

func enter(from: State) -> void:
	momentum_layer.enabled = true
