extends Node
class_name VelocityController

signal on_collision(last_slide: KinematicCollision2D)

var _layers : Array[Velocity]

func _ready() -> void:
	for child in get_children():
		if child is Velocity:
			_layers.push_back(child)
			on_collision.connect(_on_collision)

func _on_collision(velocity: Vector2, collision: KinematicCollision2D) -> void:
	var angle := absf(rad_to_deg(angle_difference(
		 collision.get_normal().angle(), 
		velocity.normalized().angle()
	)))
	for layer in _layers:
		layer.on_collision.emit(velocity, collision, angle)

func get_velocity() -> Vector2:
	var velocity := Vector2.ZERO
	for layer in _layers:
		velocity += layer.get_velocity()
	return velocity
