class_name MoveComponent
extends Node

@export var speed: float = 70.
@export var runMultiplier: float = 1.5

func getMoveVector() -> Vector2:
	var spd: float = speed
	if isRunning():
		spd *= runMultiplier
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").limit_length() * spd

func isRunning() -> bool:
	return Input.is_action_pressed("run")
