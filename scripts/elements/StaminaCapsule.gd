extends Sprite2D

@onready var areaCapsule: Area2D = $Area2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

@export var stamina: int = 5

func _ready() -> void:
	$Label.text = "+%s" % stamina
	$Label.modulate.a = 0.
	
	$Area2D.area_entered.connect(onEntered)

func onEntered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player: Player = (area.get_parent() as Player)
		if player.staminaComponent.stamina >= player.staminaComponent.maxStamina:
			return
		
		(area.get_parent() as Player).staminaComponent.stamina += stamina
		$AudioStreamPlayer.play()
		
		var tween: Tween = create_tween().bind_node(self).set_parallel()
		tween.tween_property($Label, "modulate", Color.WHITE, .45)
		tween.tween_property($Label, "position", Vector2(-5., -19.), .45)
		
		areaCapsule.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
		await tween.finished
		tween.kill()
		queue_free()
