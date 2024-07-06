extends Sprite2D

@onready var animPlayer: AnimationPlayer = $AnimationPlayer

@export var health: int = 5

func _ready() -> void:
	$Label.modulate.a = 0.

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player: Player = (area.get_parent() as Player)
		if player.healthComponent.health >= player.healthComponent.maxHealth:
			return
		
		(area.get_parent() as Player).healthComponent.health += health
		$AudioStreamPlayer.play()
		
		var tween: Tween = create_tween().bind_node(self).set_parallel()
		tween.tween_property($Label, "modulate", Color.WHITE, .45)
		tween.tween_property($Label, "position", Vector2(-5., -19.), .45)
		
		await tween.finished
		tween.kill()
		queue_free()
