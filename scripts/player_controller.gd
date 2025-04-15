extends CharacterBody2D

@export var force_layer_controller : ForceLayerController

func _physics_process(delta: float) -> void:
	if move_and_slide():
		pass
