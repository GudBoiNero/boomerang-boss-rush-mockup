extends Node2D

var is_kbm: bool = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		if !is_kbm:
			print("[%s]: Player switched to keyboard and mouse" % name)
		is_kbm = true
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if is_kbm:
			print("[%s]: Player switched to gamepad" % name)
		is_kbm = false

func get_input_raw() -> Vector2:
	var joypads := Input.get_connected_joypads()
	var input_vec := Vector2.ZERO

	if joypads.size() > 0:
		var id := joypads[0]
		if Input.is_joy_known(id):
			input_vec = Vector2(
				Input.get_joy_axis(id, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(id, JOY_AXIS_LEFT_Y)
			)

			# Apply deadzone to prevent stick drift
			var deadzone := 0.2
			if input_vec.length() < deadzone:
				input_vec = Vector2.ZERO

	# If no joystick movement, fall back to keyboard input
	if input_vec == Vector2.ZERO:
		input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	return input_vec


func get_input() -> Vector2:
	var raw := get_input_raw()
	return raw.limit_length(1.0) if raw.length() > 0.01 else Vector2.ZERO


func get_aim() -> Vector2:
	var rect := get_viewport().get_visible_rect().size
	var center := rect / 2

	var joypads := Input.get_connected_joypads()
	var input_vec := Vector2.ZERO

	if joypads.size() > 0 && !is_kbm:
		var id := joypads[0]
		if Input.is_joy_known(id):
			var raw_input := Vector2(
				Input.get_joy_axis(id, JOY_AXIS_RIGHT_X),
				Input.get_joy_axis(id, JOY_AXIS_RIGHT_Y)
			)

			# Apply deadzone
			var deadzone := 0.2
			if raw_input.length() >= deadzone:
				input_vec = raw_input.normalized()
	elif input_vec == Vector2.ZERO:
		var mouse_vec := get_local_mouse_position() - center + get_viewport_transform().get_origin()
		input_vec = mouse_vec.normalized()

	return input_vec
