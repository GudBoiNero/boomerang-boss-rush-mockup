extends Node
## Parent class built for helper functions to manage ForceLayers and Forces
class_name ForceController

## The list of ForceLayers to control
var _layers : Array[ForceLayer]

func _ready() -> void:
	for child in get_children():
		if child is ForceLayer:
			_layers.push_back(child)

func get_combined_velocity() -> Vector2:
	var velocity : Vector2 = Vector2.ZERO
	for layer in _layers:
		velocity += layer.get_combined_velocity()
	return velocity
