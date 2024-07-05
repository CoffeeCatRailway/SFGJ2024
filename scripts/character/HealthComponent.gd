class_name HealthComponent
extends Node

signal hit(isDead: bool)

@export var immortal: bool = false
@export var maxHealth: int = 100
var health: int:
	set(value):
		health = clamp(value, 0, maxHealth)

var isDead: bool = false

func _ready() -> void:
	health = maxHealth

func damage(dmg: int) -> void:
	if !immortal:
		health = clamp(health - dmg, 0, maxHealth)
		isDead = health <= 0
	hit.emit(isDead)
