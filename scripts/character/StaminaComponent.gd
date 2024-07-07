class_name StaminaComponent
extends Node

@export var moveComponent: MoveComponent

@export var maxStamina: float = 50.
@export var drainRate: float = 5.
@export var regenRate: float = 3.
var stamina: float = 0.:
	set(value):
		stamina = clamp(value, 0., maxStamina)

func _ready() -> void:
	stamina = maxStamina

func _process(delta: float) -> void:
	if moveComponent.isRunning() && moveComponent.getMoveVector().length() > 0.:
		stamina -= delta * drainRate
	else:
		stamina += delta * regenRate
