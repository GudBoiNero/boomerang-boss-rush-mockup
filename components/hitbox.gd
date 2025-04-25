@tool
@icon("res://textures/icon/hitbox.svg")
extends Area2D
class_name HitBox

@export var ignore_list : Array[HurtBox]

## list of HurtBoxes hit and not yet exited
var _registered : Array[HurtBox]

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		if area in ignore_list: return
		if area in _registered: return 
		_registered.push_back(area)
		area.hitbox_entered.emit(self)
		_on_hurtbox_hit(area)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtBox:
		if area not in _registered: return
		_registered.remove_at(_registered.find(area))
		area.hitbox_exited.emit(self)

func _on_hurtbox_hit(hurtbox: HurtBox) -> void:
	pass

func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color.RED
			child.debug_color.a8 = 107
