extends Node
class_name VelocityLayer

signal on_store(velocity: Vector2)
signal on_unstore(velocity: Vector2)

## Enables processing
@export var enabled : bool = true

## Stops processing and stores _velocity in _stored_velocity
var storing : bool = false :
	set(value):
		storing = value
		if value:
			_stored_velocity = _velocity
			_velocity = Vector2.ZERO
			on_store.emit(_stored_velocity)
		else:
			_velocity = _stored_velocity
			_stored_velocity = Vector2.ZERO
			on_unstore.emit(_velocity)

var _velocity : Vector2 = Vector2.ZERO
var _stored_velocity : Vector2 = Vector2.ZERO

#region process
func _physics_process(delta: float) -> void:
	if enabled && !storing:
		_velocity_physics_process(delta)

func _velocity_physics_process(delta: float) -> void:
	pass
#endregion

#region helpers
## returns _velocity if nothing else affects it
func get_velocity() -> Vector2:
	return _velocity

func get_stored_velocity() -> Vector2:
	return _stored_velocity

func clear() -> void:
	_velocity = Vector2.ZERO
	_stored_velocity = Vector2.ZERO
#endregion
