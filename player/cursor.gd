extends Node2D

func _physics_process(delta: float) -> void:
	var aim := PlayerInputService.get_aim()
	position = aim * 100
	look_at(aim + get_parent().global_position)
	visible = aim != Vector2.ZERO
