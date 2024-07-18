extends State

@export var idleState: State
@export var marker: Marker2D
@export var isPurple: bool = false
@export var shootSound: AudioStream
@export var audioStreamPlayer: AudioStreamPlayer2D

func update(_delta: float) -> State:
	Utils.shootBullet(get_tree().current_scene, marker.global_position, sprite.rotation, isPurple)
	
	if audioStreamPlayer:
		audioStreamPlayer.stream = shootSound
		audioStreamPlayer.play()
	
	return idleState
