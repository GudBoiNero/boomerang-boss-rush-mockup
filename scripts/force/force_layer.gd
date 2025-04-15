extends Node
class_name ForceLayer

var _forces: Array[Force]

func _ready() -> void:
	for child in get_children():
		if child is Force:
			_forces.push_back(child)

func get_combined_velocity() -> Vector2:
	var velocity : Vector2 = Vector2.ZERO

	for force in _forces:
		velocity += force.get_velocity() if is_active() else Vector2.ZERO

	return velocity

func is_active() -> bool:
	return true
