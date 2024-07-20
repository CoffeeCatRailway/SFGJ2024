extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

@export var winColor: Color = Color.hex(0x3a4d524e)
@export var loseColor: Color = Color.hex(0xd046484e)

@onready var btnPlay: Button = $Control/HBoxContainer/BtnPlay
@onready var btnQuit: Button = $Control/HBoxContainer/BtnQuit


func _ready() -> void:
	visible = false
	
	btnPlay.pressed.connect(onPlayPressed)
	btnQuit.pressed.connect(onQuitPressed)

func showMenu() -> void:
	PauseMenu.canPause = false
	visible = true
	$AnimationPlayer.play("fade")

func hideMenu() -> void:
	PauseMenu.canPause = true
	visible = false

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

func winMenu() -> void:
	showMenu()
	$Control/ColorRect.color = winColor
	$Control/Win.visible = true
	$Control/Lose.visible = false

func loseMenu() -> void:
	showMenu()
	$Control/ColorRect.color = loseColor
	$Control/Win.visible = false
	$Control/Lose.visible = true

# Win
func onPlayPressed() -> void:
	playClickSound()
	hideMenu()
	get_tree().reload_current_scene()

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()
