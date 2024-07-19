extends Node

@onready var globalSFX: AudioStreamPlayer = $GlobalSFX

func _ready() -> void:
	globalSFX.finished.connect(reset)

func playSfx(stream: AudioStream, volumeDB: float = 0.) -> void:
	globalSFX.volume_db = volumeDB
	globalSFX.stream = stream
	globalSFX.play()

func reset() -> void:
	globalSFX.volume_db = 0.
