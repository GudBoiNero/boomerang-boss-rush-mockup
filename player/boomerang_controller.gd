extends Node2D
class_name BoomerangController

@export var enabled : bool = true

@export var sprite : Sprite2D
@export var anchor : Node2D

## Whether the player has thrown the boomerang or not
var _thrown : bool = false

func _physics_process(delta: float) -> void:
	sprite.visible = !_thrown
