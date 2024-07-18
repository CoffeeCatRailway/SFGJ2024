extends StateGunIdle

@export var targeterComponent: TargeterComponent

func getLookTarget() -> Vector2:
	if targeterComponent.target:
		return targeterComponent.target.global_position
	return Vector2.INF

func shouldFire() -> bool:
	return timer.is_stopped()
