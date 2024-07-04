class_name StateGunIdle
extends State

@export var fireState: State
@export var marker: Marker2D
@export var timer: Timer
@export var minShootTime: float = .5
@export var maxShootTime: float = .75

func enter() -> void:
	timer.one_shot = true
	timer.wait_time = randf_range(minShootTime, maxShootTime)
	timer.start()

func update(_delta: float) -> State:
	if getLookTarget() == Vector2.INF:
		return null
	sprite.look_at(getLookTarget())
	sprite.rotation_degrees = fmod(sprite.rotation_degrees, 360.)
	sprite.flip_v = sprite.global_position.x > marker.global_position.x
	
	if shouldFire():
		return fireState
	return null

func getLookTarget() -> Vector2:
	return parent.get_global_mouse_position()

func shouldFire() -> bool:
	return timer.is_stopped() && Input.is_action_pressed("fire")
