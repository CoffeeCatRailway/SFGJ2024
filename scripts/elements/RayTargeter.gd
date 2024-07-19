class_name TargeterComponent
extends RayCast2D

@export var targetScript: GDScript
@export var maxDistance: float = -1.

var target: Node2D = null # Loki?

func _process(_delta: float) -> void:
	if is_colliding() && get_collider() && get_collider().get_parent().get_script() == targetScript:
		target = get_collider().get_parent()
	if !target:
		return
	
	var isDead: bool = target.get_script() == targetScript && target.healthComponent.isDead
	var isOutOfRange: bool = maxDistance > 0. && target.global_position.distance_to(get_parent().global_position) > maxDistance
	
	if isDead || isOutOfRange:
		target = null
