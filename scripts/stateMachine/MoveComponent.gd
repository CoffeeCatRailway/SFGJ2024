class_name MoveComponent
extends Node

@export var speed: float = 70.
@export var runMultiplier: float = 1.5

@export_subgroup("stamina")
## Leave empty if character does not have stamina
@export var staminaComponent: StaminaComponent
@export var noStaminaMultiplier: float = .65

func getMoveVector() -> Vector2:
	var spd: float = speed
	if isRunning():
		spd *= runMultiplier
	elif staminaComponent && staminaComponent.regen:
		spd *= noStaminaMultiplier
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").limit_length() * spd

func isRunning() -> bool:
	if staminaComponent && staminaComponent.regen:
		return false
	return Input.is_action_pressed("run")
