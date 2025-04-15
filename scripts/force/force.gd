## 

extends Node
class_name Force

const FLAG_X : int = 1 << 0
const FLAG_Y : int = 1 << 1

var _velocity : Vector2 = Vector2.ZERO

@export_category("Behavior")
@export_flags("x", "y")
var reset_flags: int

func get_velocity() -> Vector2:
	return _velocity if is_active else Vector2.ZERO

func is_active() -> bool:
	return true

## utility to remove velocity on collision based on reset_flags
func _reset_velocity(collision: KinematicCollision2D) -> void:
	if reset_flags & FLAG_X:
		_velocity.x = 0
	if reset_flags & FLAG_Y:
		_velocity.y = 0
