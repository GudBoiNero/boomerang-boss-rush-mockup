extends Velocity

## Deliberately overriding this function because I want different behaviors.
func _on_move_and_slide(velocity: Vector2, collision: KinematicCollision2D) -> void:
	if !active(): return

	if collision:
		var normal := collision.get_normal()
		_velocity = velocity.bounce(normal)
