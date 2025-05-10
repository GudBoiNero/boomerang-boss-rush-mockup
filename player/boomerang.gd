extends CharacterBody2D
class_name Boomerang

@onready var sprite : Sprite2D = $SpriteAnchor/Sprite
@onready var anchor : Node2D = $SpriteAnchor

@export var MAX_SPEED := 800
@export var MIN_SPEED := 200

@onready var _velocity : Velocity = %Velocity

var initial_strength : float = 0.0
var initial_position := Vector2.ZERO
var direction := Vector2.ZERO
var curve_left : bool = false

func curve_sign() -> int:
	return -1 if curve_left else 1

func _ready() -> void:
	var dif := MAX_SPEED - MIN_SPEED
	var strength := MIN_SPEED + (initial_strength * dif)

	_velocity.set_velocity(strength * direction)
	_velocity.start()

func _physics_process(delta: float) -> void:
	sprite.rotation_degrees += curve_sign() * velocity.length() / 16
	
	var target := _velocity.get_velocity()
	velocity = target
	if move_and_slide():
		_velocity.on_move_and_slide.emit(target, get_slide_collision(0))
	else:
		_velocity.on_move_and_slide.emit(target, null)
