extends Node
class_name State

signal state_entered(from: State)
signal state_exited(to: State)

func _state_process(delta: float) -> void:
	pass

func _state_physics_process(delta: float) -> void:
	pass
