extends State

@export var markers: Node2D
@export var healthComponent: HealthComponent

@export var bulletSpeed: float = 225.
@export var bulletDamage: int = 20
@export var shootSound: AudioStream
@export var audioStreamPlayer: AudioStreamPlayer2D
@export var timer: Timer

const ANIMATION: String = "phase2"

func enter() -> void:
	animPlayer.play(ANIMATION)
	
	timer.one_shot = true
	timer.wait_time = .25
	timer.start()

func update(_delta: float) -> State:
	markers.rotation_degrees += 1.
	
	if timer.is_stopped():
		for child: Marker2D in markers.get_children():
			Utils.shootBullet(get_tree().current_scene, child.global_position, child.transform.x.angle() + markers.rotation, true, bulletSpeed, bulletDamage)
		
		if audioStreamPlayer:
			audioStreamPlayer.stream = shootSound
			audioStreamPlayer.play()
		
		timer.start()
	
	return null
