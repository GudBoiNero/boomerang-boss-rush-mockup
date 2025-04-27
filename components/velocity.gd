@icon("res://textures/icon/velocity.svg")
extends Node
class_name Velocity

signal on_start
signal on_stop(velocity: Vector2)
signal on_pause(stored_velocity: Vector2)
signal on_resume(stored_velocity: Vector2)
signal on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D)

@export_group("Collision")
@export var STOP_ON_DIRECT_COLLISION : bool = false
@export_range(0.0, 180, 0.001, "degrees") var DIRECT_ANGLE_MARGIN : float = 45

var _velocity : Vector2 = Vector2.ZERO
var _stored_velocity : Vector2 = Vector2.ZERO
var _active : bool = false
var _paused : bool = false

#region internal
func _init() -> void:
	on_move_and_slide.connect(_on_move_and_slide)

func _process(delta: float) -> void:
	if active():
		_velocity_process(delta)

func _physics_process(delta: float) -> void:
	if active():
		_velocity_physics_process(delta)
#endregion

#region process
func _velocity_start() -> void:
	pass

func _velocity_stop() -> void:
	pass

func _velocity_resume() -> void:
	pass

func _velocity_pause() -> void:
	pass

func _velocity_process(delta: float) -> void:
	pass

func _velocity_physics_process(delta: float) -> void:
	pass

func _on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D) -> void:
	if !active(): return

	if collision:
		var normal := collision.get_normal()
		var slide_vector := _velocity.slide(normal)

		if STOP_ON_DIRECT_COLLISION:
			if is_direct_collision(velocity, collision, DIRECT_ANGLE_MARGIN):
				_velocity = Vector2.ZERO
		else:
			_velocity = slide_vector
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
## also get_velocity(true) returns velocity regardless of if paused or not
func get_velocity(and_pause: bool = false) -> Vector2:
	return _velocity if !and_pause else (_velocity if !_paused else _stored_velocity)

func get_stored_velocity() -> Vector2:
	return _stored_velocity

func start() -> void:
	_active = true
	if _paused:
		resume()
	_paused = false
	on_start.emit()
	_velocity_start()

func stop() -> void:
	_velocity = Vector2.ZERO
	_active = false
	_paused = false
	on_stop.emit(get_velocity(true))
	_velocity_stop()

func resume() -> void:
	if _active && _paused:
		_active = true
		_paused = false
		_velocity = _stored_velocity
		_stored_velocity = Vector2.ZERO
		on_resume.emit(get_velocity(true))
		_velocity_resume()

func pause() -> void:
	if _active && !_paused:
		_active = false
		_paused = true
		_stored_velocity = _velocity
		_velocity = Vector2.ZERO
		on_pause.emit(get_velocity(true))
		_velocity_pause()

func active() -> bool:
	return _active

func paused() -> bool:
	return _paused
#endregion
