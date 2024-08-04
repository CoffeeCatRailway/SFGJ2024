extends Node

const BULLET_SCENE: PackedScene = preload("res://scenes/elements/bullet.tscn")

func shootBullet(parent: Node2D, pos: Vector2, angle: float, isPurple: bool, speed: float = 200., damage: int = 10) -> void:
	var bullet: Bullet = BULLET_SCENE.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	parent.add_child(bullet)
	bullet.speed = speed
	bullet.damage = damage
	bullet.global_position = pos
	bullet.setDirection(Vector2(1., 0.).rotated(angle))
	bullet.isPurple = isPurple

func tweenBounce(node: Node, x: float = .8, y: float = 1.4) -> void:
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2(x, y), .04)
	tween.tween_property(node, "scale", Vector2.ONE, .04)
	await tween.finished
	tween.kill()

func isMoveKeyPressed() -> bool:
	return Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")
