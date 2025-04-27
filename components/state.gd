@icon("res://textures/icon/state.svg")
extends Node
class_name State

signal state_entered(from: State)
signal state_exited(to: State)

var _data : Variant

func _is_data_valid(value: Variant) -> bool:
	return true

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

func get_data() -> Variant:
	return _data

func set_data(data: Variant) -> void:
	## This allows us to insert some boundaries and keep-
	##-state transferred data safer
	assert(_is_data_valid(data))
	_data = data

func clear_data() -> void:
	_data = null
