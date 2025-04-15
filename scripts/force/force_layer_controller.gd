extends Node
class_name ForceLayerController

@export var layers: Array[ForceLayer]

func get_combined_velocity() -> Vector2:
	var velocity : Vector2 = Vector2.ZERO

	for layer in layers:
		velocity += layer.get_combined_velocity()

	return velocity
