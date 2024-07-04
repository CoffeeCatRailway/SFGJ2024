extends State

@export var idleState: State
@export var marker: Marker2D
@export var bulletScene: PackedScene
@export var isPurple: bool = false

func update(_delta: float) -> State:
	var bullet: Bullet = bulletScene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = marker.global_position
	bullet.setDirection(Vector2(1., 0.).rotated(sprite.rotation))
	bullet.isPurple = isPurple
	return idleState
