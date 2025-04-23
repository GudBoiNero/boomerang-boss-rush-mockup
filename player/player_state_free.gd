extends State

@onready var momentum_layer: PlayerMomentumVelocityLayer = %MomentumVelocityLayer

func _ready() -> void:
	state_entered.connect(enter)

func enter(from: State) -> void:
	momentum_layer.enabled = true
