extends StateGunIdle

@export var robot: Robot

func getLookTarget() -> Vector2:
	if robot.rayTarget:
		return robot.rayTarget.global_position
	return Vector2.INF

func shouldFire() -> bool:
	return timer.is_stopped()
