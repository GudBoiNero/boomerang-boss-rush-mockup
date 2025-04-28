extends Node2D
class_name BoomerangController

@onready var BOOMERANG_SCENE : PackedScene = preload("res://player/boomerang.tscn")

@export var enabled : bool = true
@export var TIME_TO_MAX : float = 0.7
@export var sprite : Sprite2D
@export var anchor : Node2D

## Whether the player has thrown the boomerang or not
var _thrown : bool = false
var _held : float = 0
## left or right curve based on last held input
var last_curve : bool = false

func _physics_process(delta: float) -> void:
	var aim := PlayerInputService.get_aim_input()
	sprite.visible = !_thrown
	anchor.rotation = aim.angle()
	anchor.scale.y = sign(aim.x)

	if PlayerInputService.is_throw_pressed():
		_held = min(TIME_TO_MAX, _held + delta)

	if PlayerInputService.is_throw_just_released():
		var boomerang : Boomerang = BOOMERANG_SCENE.instantiate() as Boomerang

		boomerang.position = global_position
		boomerang.initial_position = global_position
		boomerang.initial_strength = _held / TIME_TO_MAX
		boomerang.direction = aim
		boomerang.curve_left = PlayerInputService.last_throw_held() == -1

		get_parent().get_parent().add_child(boomerang)
		_held = 0.0
