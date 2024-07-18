class_name Door
extends Sprite2D

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var lockAnimPlayer: AnimationPlayer = $LockAnimationPlayer

@export var speed: float = 1.
@export var locked: bool = false
@export var isPurple: bool = false

func _ready() -> void:
	animPlayer.play("close", -1., 10.)
	if locked:
		lock(10.)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !locked:# && body.name == "Player":
		animPlayer.play("open", -1., speed)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if !locked:# && body.name == "Player":
		animPlayer.play("close", -1., speed)

func lock(_speed: float = speed) -> void:
	locked = true
	lockAnimPlayer.play("lock" + ("Purple" if isPurple else "Green"), -1., _speed)

func unlock() -> void:
	locked = false
	lockAnimPlayer.play("unlock" + ("Purple" if isPurple else "Green"), -1., speed)
