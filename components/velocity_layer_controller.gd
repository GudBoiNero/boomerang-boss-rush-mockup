extends Node
class_name VelocityLayerController

var _layers : Array[VelocityLayer]

func _ready() -> void:
	for child in get_children():
		if child is VelocityLayer:
			_layers.push_back(child)

func get_velocity() -> Vector2:
	var velocity := Vector2.ZERO
	for layer in _layers:
		velocity += layer.get_velocity()
	return velocity
