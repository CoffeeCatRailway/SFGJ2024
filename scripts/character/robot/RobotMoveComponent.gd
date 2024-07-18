extends MoveComponent

@export var targeterComponent: TargeterComponent
@export var minFollowDist: float = 30.

func getMoveVector() -> Vector2:
	if !targeterComponent.target:
		return Vector2.ZERO
	
	var dir: Vector2 = (targeterComponent.target.global_position - targeterComponent.global_position)
	if dir.length() < minFollowDist:
		return Vector2.ZERO
	return dir.limit_length() * speed

func isRunning() -> bool:
	return false
