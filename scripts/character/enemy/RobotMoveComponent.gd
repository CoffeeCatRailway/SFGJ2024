extends MoveComponent

@export var robot: Robot
@export var minFollowDist: float = 30.

func getMoveVector() -> Vector2:
	if !robot.rayTarget:
		return Vector2.ZERO
	
	var dir: Vector2 = (robot.rayTarget.global_position - robot.global_position)
	if dir.length() < minFollowDist:
		return Vector2.ZERO
	return dir.limit_length() * speed

func isRunning() -> bool:
	return false
