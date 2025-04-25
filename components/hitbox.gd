@tool
@icon("res://textures/icon/hitbox.svg")
extends Area2D
class_name HitBox

signal hurtbox_entered(hurtbox: HurtBox)
signal hurtbox_exited(hurtbox: HurtBox)

## A list of HurtBoxes you want to ignore. Realistically only ever one would be used
@export var context : HitBoxContext
@export var ignore_list : Array[HurtBox]
@export_group("Lifetime")
@export var always_active : bool = false
## TODO: Implement
@export var duration : float = 0.1
@export_group("Special Effects")
## TODO: Implement
@export var hit_effect: PackedScene

## list of HurtBoxes hit and not yet exited
var _registered : Array[HurtBox]
var _active : bool = false : 
	set(value):
		_active = value
		if !_active:
			_time_left = 0.0
			## We wanna clear _registered just in case we hit something-
			##-then immediately deactivate
			_registered.clear()
		else:
			_time_left = duration
var _time_left : float = 0.0

#region process
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	if _time_left == 0:
		deactivate()
	_time_left = max(0, _time_left - delta)

func _on_area_entered(area: Area2D) -> void:
	if !_active and !always_active: return

	if area is HurtBox:
		if area in ignore_list: return
		if area in _registered: return 
		_registered.push_back(area)
		area.hitbox_entered.emit(context)
		hurtbox_entered.emit(area)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtBox:
		if area not in _registered: return
		_registered.remove_at(_registered.find(area))
		area.hitbox_exited.emit(context)
		hurtbox_exited.emit(area)
#endregion

#region helpers
func activate() -> void:
	_active = true

func deactivate() -> void:
	_active = false
#endregion

#region tool
func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color.RED 
			child.debug_color.a8 = 107
#endregion
