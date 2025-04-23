extends Node
class_name StateMachine

signal state_changed(to: State, from: State)

@export var INITIAL_STATE: State

@onready var state: State = (func(): 
	INITIAL_STATE.state_entered.emit(null)
	return INITIAL_STATE
).call():
	set(new):
		print("huyh")
		var old := state
		state = new
		state_changed.emit(new, old)
		old.state_exited.emit(new)
		new.state_entered.emit(old)

func _process(delta: float) -> void:
	if state:
		state._state_process(delta)

func _physics_process(delta: float) -> void:
	if state:
		state._state_physics_process(delta)
