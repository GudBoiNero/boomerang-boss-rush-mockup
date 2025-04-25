@icon("res://textures/icon/velocity.svg")
extends Node
class_name Velocity

signal on_store(velocity: Vector2)
signal on_unstore(velocity: Vector2)
signal on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D)

## Enables processing
@export var enabled : bool = true

@export_group("Collision")
@export var STOP_ON_DIRECT_COLLISION : bool = false
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

#region process
func _init() -> void:
	on_move_and_slide.connect(_on_move_and_slide)

func _process(delta: float) -> void:
	if enabled && !storing:
		_velocity_process(delta)

func _physics_process(delta: float) -> void:
	if enabled && !storing:
		_velocity_physics_process(delta)

func _velocity_process(delta: float) -> void:
	pass

func _velocity_physics_process(delta: float) -> void:
	pass

func _on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D) -> void:
	if collision:
		var remainder := collision.get_remainder()
		var normal := collision.get_normal()

		var slide_vector := velocity.slide(normal)
		var angle_diff := rad_to_deg(angle_difference(velocity.angle(), slide_vector.angle()))

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
func get_velocity() -> Vector2:
	return _velocity

func get_stored_velocity() -> Vector2:
	return _stored_velocity

func clear() -> void:
	_velocity = Vector2.ZERO
	_stored_velocity = Vector2.ZERO
#endregion
