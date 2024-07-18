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
		activate()
	else:
		deactivate()

func activate() -> void:
	active = true
	animPlayer.play("active" + ("Purple" if isPurple else "Green"))
	audio.play()
	
	door.lock()

func deactivate() -> void:
	active = false
	animPlayer.play("unactive" + ("Purple" if isPurple else "Green"))
	audio.play()
	
	door.unlock()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name != "Bullet":
		return
	
	if active:
		deactivate()
	else:
		activate()
