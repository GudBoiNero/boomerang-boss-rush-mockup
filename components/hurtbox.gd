@tool
@icon("res://textures/icon/hurtbox.svg")
extends Area2D
class_name HurtBox

@export var health_component: HealthComponent

signal hitbox_entered(context: HitBoxContext)
signal hitbox_exited(context: HitBoxContext)

#region process
func _ready() -> void:
	hitbox_entered.connect(_hit)

func _hit(context: HitBoxContext) -> void:
	if health_component:
		health_component.damage(context)

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.debug_color = Color.GREEN
			child.debug_color.a8 = 107
#endregion
