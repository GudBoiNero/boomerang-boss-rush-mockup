extends Node
## Class designed to contain groups of Forces and manage them
class_name ForceLayer

@export var enabled : bool = false

var _forces: Array[Force]

func _ready() -> void:
	for child in get_children():
		if child is Force:
			_forces.push_back(child)

func get_combined_velocity() -> Vector2:
	var velocity : Vector2 = Vector2.ZERO
	for force in _forces:
		velocity += force.get_velocity()
	return velocity
