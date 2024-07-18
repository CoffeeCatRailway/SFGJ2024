class_name TargeterComponent
extends RayCast2D

@export var targetScript: GDScript

var target: Node2D = null # Loki?

func _process(_delta: float) -> void:
	if is_colliding() && get_collider() && get_collider().get_parent().get_script() == targetScript:
		target = get_collider().get_parent()
	if !target:
		return
	
	if target.get_script() == targetScript && target.healthComponent.isDead:
		target = null
