@icon("res://textures/icon/state_machine.svg")
extends Node
class_name StateMachine

signal state_changed(to: State, from: State)

@export var INITIAL_STATE: State

@onready var _state: State = (func() -> State: 
	_state_changed(INITIAL_STATE, null)
	return INITIAL_STATE
).call()

func set_state(new: State) -> void:
	_state_changed(new, _state)

func _state_changed(to: State, from: State) -> void:
	state_changed.emit(to, from)
	to.state_entered.emit(from)
	if from:
		from.state_exited.emit(to)

func _process(delta: float) -> void:
	if _state:
		_state._state_process(delta)

func _physics_process(delta: float) -> void:
	if _state:
		_state._state_physics_process(delta)
