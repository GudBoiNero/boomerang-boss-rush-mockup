@icon("res://textures/icon/health_component.svg")
extends Node
class_name HealthComponent

signal health_depleted(hitbox: HitBoxContext)
signal health_damaged(hitbox: HitBoxContext)

@export var _health : int = 3

func damage(context: HitBoxContext) -> void:
	_health = max(0, _health - context.damage)
	health_damaged.emit(context)
	if _health == 0:
		health_depleted.emit(context)
