extends ProgressBar

@export var healthComponent: HealthComponent

func _ready() -> void:
	max_value = healthComponent.maxHealth

func _process(_delta: float) -> void:
	value = healthComponent.health
