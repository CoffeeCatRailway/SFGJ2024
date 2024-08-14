extends Area2D

const COLOR_TRANSPARENT: Color = Color(1., 1., 1., 0.)

@export var speed: float = .5
@export var triggerScript: GDScript

@export var toggle: bool = false

var parent: Variant
var tween: Tween

func _ready() -> void:
	parent = get_parent()
	if !parent:
		return
	
	body_entered.connect(onEntered)
	body_exited.connect(onExited)

func onEntered(body: Node2D) -> void:
	if body.get_script() != triggerScript:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(parent, "modulate", COLOR_TRANSPARENT, speed)

func onExited(body: Node2D) -> void:
	if body.get_script() != triggerScript || toggle:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(parent, "modulate", Color.WHITE, speed)
