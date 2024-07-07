extends Control

@onready var player: Player = %Player

func _ready() -> void:
	$HBoxContainer/Health/TextureProgressBar.max_value = player.healthComponent.maxHealth
	$HBoxContainer/Stamina/TextureProgressBar.max_value = player.staminaComponent.maxStamina

func _process(_delta: float) -> void:
	# Health
	$HBoxContainer/Health/TextureProgressBar.value = player.healthComponent.health
	$HBoxContainer/Health/Label.text = "%s/%s" % [player.healthComponent.health, player.healthComponent.maxHealth]
	
	# Stamina
	$HBoxContainer/Stamina/TextureProgressBar.value = player.staminaComponent.stamina
	$HBoxContainer/Stamina/Label.text = "%.1f/%s" % [player.staminaComponent.stamina, player.staminaComponent.maxStamina]
