@icon("res://textures/icon/health_component.svg")
extends Node
class_name HealthComponent

signal health_depleted(hitbox: HitBox)
signal health_damaged(hitbox: HitBox)

@export var _health : int = 3

func damage(hitbox: HitBox) -> void:
	pass
