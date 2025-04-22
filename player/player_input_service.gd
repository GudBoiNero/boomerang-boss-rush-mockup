extends Node

func get_input_raw() -> Vector2:
	var joypads := Input.get_connected_joypads()
	var input_vec := Vector2.ZERO

	if joypads.size() > 0:
		var id = joypads[0]
		if Input.is_joy_known(id):
			input_vec = Vector2(
				Input.get_joy_axis(id, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(id, JOY_AXIS_LEFT_Y)
			)

			# Apply deadzone to prevent stick drift
			var deadzone := 0.1
			if input_vec.length() < deadzone:
				input_vec = Vector2.ZERO

	# If no joystick movement, fall back to keyboard input
	if input_vec == Vector2.ZERO:
		input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	return input_vec


func get_input() -> Vector2:
	return get_input_raw().normalized()
