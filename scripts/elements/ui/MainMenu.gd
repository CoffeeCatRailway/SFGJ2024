class_name MainMenu
extends Node2D

@export var level: PackedScene = preload("res://scenes/levels/level.tscn")

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

@onready var btnPlay: Button = $CanvasMain/VBoxContainer/BtnPlay
@onready var btnQuit: Button = $CanvasMain/VBoxContainer/BtnQuit

var creditsToggle: bool = false
@onready var btnCredits: TextureButton = $CanvasCommon/BtnCredits

@onready var labelArt: RichTextLabel = $CanvasCredits/LabelArt
@onready var labelSound: RichTextLabel = $CanvasCredits/LabelSound
@onready var labelMusic: RichTextLabel = $CanvasCredits/LabelMusic

func _ready() -> void:
	PauseMenu.canPause = false
	$CanvasMain.visible = true
	$CanvasCredits.visible = false
	
	btnPlay.pressed.connect(onPlayPressed)
	btnQuit.pressed.connect(onQuitPressed)
	
	btnCredits.pressed.connect(onCreditsPressed)
	
	labelArt.meta_clicked.connect(handleRichTextMetaClick)
	labelSound.meta_clicked.connect(handleRichTextMetaClick)
	labelMusic.meta_clicked.connect(handleRichTextMetaClick)

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

# Main Menu
func onPlayPressed() -> void:
	playClickSound()
	get_tree().change_scene_to_packed(level)

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()

# Credits Menu
func handleRichTextMetaClick(meta: Variant) -> void:
	OS.shell_open(str(meta))

func onCreditsPressed() -> void:
	playClickSound()
	if !creditsToggle:
		$CanvasMain.visible = false
		$CanvasCredits.visible = true
		creditsToggle = true
	else:
		$CanvasMain.visible = true
		$CanvasCredits.visible = false
		creditsToggle = false
