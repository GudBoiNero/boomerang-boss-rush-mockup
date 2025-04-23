extends Node
class_name Velocity

signal on_store(velocity: Vector2)
signal on_unstore(velocity: Vector2)

## Enables processing
@export var enabled : bool = true

@export_group("Collision")
@export_range(0.0, 180, 0.001) var ANGLE_ERROR_MARGIN : float = 45

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

func _on_collision(velocity: Vector2, collision: KinematicCollision2D) -> void:
	var col_angle := collision.get_normal().angle()
	var vel_angle := velocity.normalized().angle()
	var sum_angle := (angle_difference(vel_angle, col_angle))
	# col_angle works as expected
	print(roundi(rad_to_deg(sum_angle)))
	%Cursor.rotation = sum_angle
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
