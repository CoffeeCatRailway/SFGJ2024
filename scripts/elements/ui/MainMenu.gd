extends Node2D

@export var level: PackedScene = preload("res://scenes/levels/level.tscn")

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

@onready var btnPlay: Button = $CanvasLayer/VBoxContainer/BtnPlay
@onready var btnQuit: Button = $CanvasLayer/VBoxContainer/BtnQuit

func _ready() -> void:
	PauseMenu.canPause = false
	btnPlay.pressed.connect(onPlayPressed)
	btnQuit.pressed.connect(onQuitPressed)

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

func onPlayPressed() -> void:
	playClickSound()
	get_tree().change_scene_to_packed(level)

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()
