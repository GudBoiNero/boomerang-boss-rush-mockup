extends CharacterBody2D
class_name Boomerang

@onready var sprite : Sprite2D = $SpriteAnchor/Sprite
@onready var anchor : Node2D = $SpriteAnchor

@export var MAX_DISTANCE := 600
@export var MAX_WIDTH := 200

var initial_strength : float = 0.0
var initial_position := Vector2.ZERO
var direction := Vector2.ZERO
var curve_left : bool = false

var target_x : float = 0.0
var target_y : float = 0.0

func curve_sign() -> int:
	return -1 if curve_left else 1

func _ready() -> void:
	target_x = initial_position.x + (MAX_WIDTH / 2) * curve_sign()
	target_y = initial_position.y - MAX_DISTANCE
	velocity = MAX_DISTANCE * initial_strength * direction

func _physics_process(delta: float) -> void:
	anchor.look_at(position + velocity.normalized())
	sprite.rotation_degrees += curve_sign() * velocity.length() / 8
	move_and_slide()
