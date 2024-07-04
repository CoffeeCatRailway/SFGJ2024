extends State

@export var walkState: State
@export var deathState: State
@export var healthComponent: HealthComponent

const IDLE_ANIMATION: String = "idle"

func enter() -> void:
	animPlayer.play(IDLE_ANIMATION)
	parent.velocity = Vector2.ZERO

func update(_delta: float) -> State:
	if healthComponent.health <= 0:
		return deathState
	
	if Utils.isMoveKeyPressed():
		return walkState
	return null
