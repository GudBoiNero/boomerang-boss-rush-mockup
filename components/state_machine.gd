extends Node
class_name StateMachine

signal state_changed(to: State, from: State)

@export var INITIAL_STATE: State

@onready var state: State = (func(): 
	_state_changed(INITIAL_STATE, null)
	return INITIAL_STATE
).call():
	set(new):
		var old := state
		state = new
		_state_changed(new, old)

func _state_changed(to: State, from: State) -> void:
	state_changed.emit(to, from)
	to.state_entered.emit(from)
	if from:
		from.state_exited.emit(to)

func _process(delta: float) -> void:
	if state:
		state._state_process(delta)

func _physics_process(delta: float) -> void:
	if state:
		state._state_physics_process(delta)
