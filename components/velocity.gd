extends Node
class_name Velocity

signal on_store(velocity: Vector2)
signal on_unstore(velocity: Vector2)
signal on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D)

## Enables processing
@export var enabled : bool = true

@export_group("Collision")
@export var STOP_ON_DIRECT_COLLISION : bool = true
@export_range(0.0, 180, 0.001, "degrees") var DIRECT_ANGLE_MARGIN : float = 45

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
## Internally managed- describes if body is currently on a diagonal surface,
## when true: _diag_surface_mod modifies the returned _velocity in get_velocity
## to account for the diagonal surface sliding
## when set to false: _velocity is set to _velocity * _diag_surface_mod
var _on_diag_surface : bool = false :
	set(value):
		_on_diag_surface = value
		if !_on_diag_surface:
			_velocity *= _diag_surface_mod
var _diag_surface_mod : Vector2 = Vector2.ZERO

#region process
func _init() -> void:
	on_move_and_slide.connect(_on_move_and_slide)

func _physics_process(delta: float) -> void:
	if enabled && !storing:
		if _on_diag_surface:
			pass
		_velocity_physics_process(delta)

func _velocity_physics_process(delta: float) -> void:
	pass

func _on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D) -> void:
	if collision:
		var normal := collision.get_normal().rotated(PI / 2).abs()
		if normal.x == 1:
			_velocity.y = 0
			if _on_diag_surface:
				_on_diag_surface = false
		elif normal.y == 1:
			_velocity.x = 0
			if _on_diag_surface:
				_on_diag_surface = false
		else:
			_on_diag_surface = true
			_diag_surface_mod = normal
	else:
		if _on_diag_surface:
			_on_diag_surface = false
#endregion

#region helpers
func is_direct_collision(velocity: Vector2, collision: KinematicCollision2D, margin: float) -> bool:
	var col_angle := collision.get_normal().angle()
	var vel_angle := velocity.normalized().angle()
	var dif_angle := rad_to_deg(angle_difference(vel_angle, col_angle))

	## We round so 134.999 and 135.001 are 135
	var abs_angle := roundi(absf(dif_angle))
	return abs_angle > 180 - margin
## returns _velocity if nothing else affects it
func get_velocity() -> Vector2:
	return _velocity

func get_stored_velocity() -> Vector2:
	return _stored_velocity

func clear() -> void:
	_velocity = Vector2.ZERO
	_stored_velocity = Vector2.ZERO
#endregion
