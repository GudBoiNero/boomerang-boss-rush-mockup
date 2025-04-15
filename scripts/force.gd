extends Node
class_name Force

var _retained_velocity : Vector2 = Vector2.ZERO
var _velocity : Vector2 = Vector2.ZERO

## Turn physics processing off and retain current _velocity until unfrozen
var frozen : bool = false :
	set(val):
		if val:
			_retained_velocity = _velocity
		else:
			_velocity = _retained_velocity
		frozen = val


#region Helpers
func freeze() -> void:
	frozen = true


func unfreeze() -> void:
	frozen = false


func get_velocity() -> Vector2:
	return _velocity
#endregion


#region Process
func _physics_process(delta: float) -> void:
	if !frozen:
		_force_physics_process(delta)


func _force_physics_process(_delta: float) -> void:
	pass
#endregion
