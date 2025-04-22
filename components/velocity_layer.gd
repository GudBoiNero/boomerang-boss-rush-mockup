extends Node
class_name VelocityLayer

signal on_store(velocity: Vector2)
signal on_unstore(velocity: Vector2)

@export var enabled : bool = true

var _velocity : Vector2 = Vector2.ZERO
var _stored_velocity : Vector2 = Vector2.ZERO
var _storing : bool = false :
	set(value):
		_storing = value
		if value:
			_stored_velocity = _velocity
			_velocity = Vector2.ZERO
			on_store.emit(_stored_velocity)
		else:
			_velocity = _stored_velocity
			_stored_velocity = Vector2.ZERO
			on_unstore.emit(_velocity)

#region process
func _physics_process(delta: float) -> void:
	if enabled && !_storing:
		_velocity_physics_process(delta)

func _velocity_physics_process(delta: float) -> void:
	pass
#endregion

#region helpers
## returns _velocity if nothing else affects it
func get_output_velocity() -> Vector2:
	return (_velocity if !_storing else _stored_velocity) if enabled else Vector2.ZERO

func get_velocity() -> Vector2:
	return _velocity

func get_stored_velocity() -> Vector2:
	return _stored_velocity

func is_storing() -> bool:
	return _storing

func store() -> void:
	_storing = true

func unstore() -> void:
	_storing = false
#endregion
