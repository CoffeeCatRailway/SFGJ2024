extends HSlider

const TENTH: float = 1. / 10.

func _process(_delta: float) -> void:
	if !has_focus():
		return
	
	if Input.is_action_just_pressed("dpad_left"):
		value -= max_value * TENTH
	elif Input.is_action_just_pressed("dpad_right"):
		value += max_value * TENTH
