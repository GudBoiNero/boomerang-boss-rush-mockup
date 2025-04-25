@icon("res://textures/icon/state.svg")
extends Node
class_name State

signal state_entered(from: State)
signal state_exited(to: State)

func _ready() -> void:
	state_entered.connect(_state_entered)
	state_exited.connect(_state_exited)

func _state_entered(from: State) -> void:
	pass

func _state_exited(to: State) -> void:
	pass

func _state_process(delta: float) -> void:
	pass

func _state_physics_process(delta: float) -> void:
	pass
