extends State

@export var phase2State: State

@export var markers: Node2D
@export var healthComponent: HealthComponent
@export var targeterComponent: TargeterComponent

@export var bulletSpeed: float = 215.
@export var bulletDamage: int = 15
@export var shootSound: AudioStream
@export var audioStreamPlayer: AudioStreamPlayer2D
@export var timer: Timer

const ANIMATION: String = "phase1"

func enter() -> void:
	animPlayer.play(ANIMATION)
	
	timer.one_shot = true
	timer.wait_time = .45
	timer.start()

func update(_delta: float) -> State:
	if healthComponent.health < healthComponent.maxHealth / 2.:
		return phase2State
	
	markers.look_at(targeterComponent.target.global_position)
	
	if timer.is_stopped():
		Utils.shootBullet(get_tree().current_scene, markers.get_child(0).global_position, markers.rotation, true, bulletSpeed, bulletDamage)
		
		if audioStreamPlayer:
			audioStreamPlayer.stream = shootSound
			audioStreamPlayer.play()
		timer.start()
	
	return null
