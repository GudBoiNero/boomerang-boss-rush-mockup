@tool
@icon("res://textures/icon/hurtbox.svg")
extends Area2D
class_name HurtBox

signal hitbox_entered(hitbox: HitBox)
signal hitbox_exited(hitbox: HitBox)

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.debug_color = Color.GRAY
