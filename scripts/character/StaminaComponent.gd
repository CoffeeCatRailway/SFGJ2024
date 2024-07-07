class_name StaminaComponent
extends Node

@export var moveComponent: MoveComponent

@export var maxStamina: float = 50.
@export var drainRate: float = 5.
@export var regenRate: float = 3.
var stamina: float = .01:
	set(value):
		stamina = clamp(value, 0., maxStamina)

var regen: bool = false
@export var regenThreshold: float = .1

func _ready() -> void:
	stamina = maxStamina

func _process(delta: float) -> void:
	if stamina >= maxStamina: # Check outside regen if statement incase of outside changes (capsules)
		regen = false
	elif stamina <= regenThreshold:
		regen = true
	
	if regen:
		stamina += delta * regenRate
	elif moveComponent.isRunning() && moveComponent.getMoveVector().length() > 0.:
		stamina -= delta * drainRate
