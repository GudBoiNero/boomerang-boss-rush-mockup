@tool
@icon("res://textures/icon/hitbox.svg")
extends Area2D
class_name HitBox

signal hurtbox_entered(hurtbox: HurtBox)
signal hurtbox_exited(hurtbox: HurtBox)

@export var ignore_list : Array[HurtBox]

@export var damage : int = 1
@export_group("Lifetime")
@export var always_active : bool = false
@export var duration : float = 0.1
@export_group("Knockback")
@export var does_kb : bool = false
@export var kb_duration : float = 0.2
## force of knockback
@export var kb_force : float = 1000.0
@export var kb_type : KnockbackTypes = KnockbackTypes.OUTWARDS
## Overrides get_kb_direction if non zero value
@export var kb_direction : Vector2 = Vector2.ZERO

enum KnockbackTypes {
	## DIRECTIONAL: kb_direction or if null- get_kb_direction()
	DIRECTIONAL,
	## OUTWARDS: from center of hitbox towards hurtbox hit
	OUTWARDS
}

## list of HurtBoxes hit and not yet exited
var _registered : Array[HurtBox]
var _active : bool = false : 
	set(value):
		_active = value
		if !_active:
			_registered.clear()

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if !_active: return

	if area is HurtBox:
		if area in ignore_list: return
		if area in _registered: return 
		_registered.push_back(area)
		area.hitbox_entered.emit(self)
		hurtbox_entered.emit(area)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtBox:
		if area not in _registered: return
		_registered.remove_at(_registered.find(area))
		area.hitbox_exited.emit(self)
		hurtbox_exited.emit(area)

func get_kb_direction() -> Vector2:
	return Vector2.ZERO

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color.RED 
			child.debug_color.a8 = 107
