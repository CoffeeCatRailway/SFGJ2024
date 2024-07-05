extends Control

@export var player: Player

func _ready() -> void:
	$TextureProgressBar.max_value = player.healthComponent.maxHealth

func _process(_delta: float) -> void:
	$TextureProgressBar.value = player.healthComponent.health
	$Label.text = "%s/%s" % [player.healthComponent.health, player.healthComponent.maxHealth]
