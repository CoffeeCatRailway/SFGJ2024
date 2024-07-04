extends State

@export var idleState: State
@export var deathState: State
@export var healthComponent: HealthComponent

const WALK_ANIMATION: String = "walk"
const RUN_ANIMATION: String = "walk"

func update(delta: float) -> State:
	if healthComponent.health <= 0:
		return deathState
	return null

func updatePhysics(_delta: float) -> State:
	if moveComponent.isRunning():
		animPlayer.play(RUN_ANIMATION)
	else:
		animPlayer.play(WALK_ANIMATION)
	
	parent.velocity = moveComponent.getMoveVector()
	
	if parent.velocity == Vector2.ZERO:
		return idleState
	
	sprite.flip_h = parent.velocity.x < 0.
	parent.move_and_slide()
	
	return null
