extends State

@export var phase1State: State
@export var targeterComponent: TargeterComponent

func enter() -> void:
	parent.velocity = Vector2.ZERO

func update(_delta: float) -> State:
	if targeterComponent.target:
		return phase1State
	return null
