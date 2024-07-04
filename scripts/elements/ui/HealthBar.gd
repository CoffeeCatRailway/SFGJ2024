extends Control

@export var player: Player

func _ready():
	$TextureProgressBar.max_value = player.healthComponent.maxHealth

func _process(delta):
	$TextureProgressBar.value = player.healthComponent.health
	$Label.text = "%s/%s" % [player.healthComponent.health, player.healthComponent.maxHealth]
