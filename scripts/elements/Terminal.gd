extends Sprite2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

@export var active: bool = false
@export var isPurple: bool = false

@export var door: Door

func _ready() -> void:
	call_deferred("readyPost")

func readyPost() -> void:
	if active:
		activate(-100.)
	else:
		deactivate(-100.)

func activate(volume: float = 0.) -> void:
	active = true
	animPlayer.play("active" + ("Purple" if isPurple else "Green"))
	audio.volume_db = volume
	audio.play()
	
	door.lock()

func deactivate(volume: float = 0.) -> void:
	active = false
	animPlayer.play("unactive" + ("Purple" if isPurple else "Green"))
	audio.volume_db = volume
	audio.play()
	
	door.unlock()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name != "Bullet":
		return
	
	if active:
		deactivate()
	else:
		activate()
