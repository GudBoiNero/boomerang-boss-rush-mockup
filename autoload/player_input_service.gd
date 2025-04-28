extends Node2D

var is_kbm: bool = true
var player : PlayerController = null

## -1 = unused since last throw
## 0 = used but then unheld
## 1 = used
var _held_l : int = -1
var _held_r : int = -1
var _held_current : int = 0
var _held_last : int = _held_current


#region process
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		if !is_kbm:
			print("[%s]: Player switched to keyboard and mouse" % name)
		is_kbm = true
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if is_kbm:
			print("[%s]: Player switched to gamepad" % name)
		is_kbm = false


func _physics_process(delta: float) -> void:
	handle_find_held_current()


func handle_find_held_current() -> void:
	_held_last = _held_current

	var throw_r : bool = Input.is_action_pressed("throw_right")
	var throw_l : bool = Input.is_action_pressed("throw_left")
	var throw_just_r : bool = Input.is_action_just_released("throw_right")
	var throw_just_l : bool = Input.is_action_just_released("throw_left")

	if !is_throw_pressed():
		_held_current = 0
		_held_l = -1
		_held_r = -1
	else:
		## Just released L
		if throw_just_l:
			_held_l = 0
		## Just released R
		if throw_just_r:
			_held_r = 0
		## Holding L only
		if !throw_r and throw_l:
			_held_l = 1
			_held_current = -1
		## Holding R only
		elif throw_r and !throw_l:
			_held_r = 1
			_held_current = 1
		else:
			_held_l = 1
			_held_r = 1
#endregion process


func is_throw_pressed() -> bool:
	return Input.is_action_pressed("throw_left") or Input.is_action_pressed("throw_right")


func is_throw_just_pressed() -> bool:
	return Input.is_action_just_pressed("throw_left") or Input.is_action_just_pressed("throw_right")


func is_throw_just_released() -> bool:
	return (
		Input.is_action_just_released("throw_left") and !Input.is_action_pressed("throw_right")
	) or (
		Input.is_action_just_released("throw_right") and !Input.is_action_pressed("throw_left")
	)


func last_throw_held() -> int:
	return _held_last


func current_throw_held() -> int:
	return _held_current


func get_move_input_raw() -> Vector2:
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


func get_move_input() -> Vector2:
	var raw := get_move_input_raw()
	return raw.limit_length(1.0) if raw.length() > 0.01 else Vector2.ZERO


func get_aim_input() -> Vector2:
	if !player: return Vector2.ZERO

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
		var mouse_vec := get_global_mouse_position() - player.position
		input_vec = mouse_vec.normalized()

	return input_vec
