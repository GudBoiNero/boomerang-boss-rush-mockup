extends Node2D

@onready var player : PlayerController = get_parent()

func _physics_process(delta: float) -> void:
	return
	var aim := PlayerInputService.get_aim()
	position = aim * 10
	look_at(aim + player.global_position)
	visible = aim != Vector2.ZERO
