class_name MainMenu
extends Node2D

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

var creditsToggle: bool = false
@onready var btnCredits: Button = $CanvasLayer/BtnCredits

@export var levelScene: PackedScene = preload("res://scenes/levels/level.tscn")
@onready var btnPlay: Button = $CanvasLayer/VBoxContainer/BtnPlay
@onready var btnSettings: Button = $CanvasLayer/VBoxContainer/BtnSettings
@onready var btnQuit: Button = $CanvasLayer/VBoxContainer/BtnQuit

@onready var settings: SettingsMenu = $CanvasLayer/SettingsMenu

@onready var labelArt: RichTextLabel = $CanvasLayer/Credits/LabelArt
@onready var labelSound: RichTextLabel = $CanvasLayer/Credits/LabelSound
@onready var labelMusic: RichTextLabel = $CanvasLayer/Credits/LabelMusic

func _ready() -> void:
	PauseMenu.canPause = false
	$CanvasLayer/VBoxContainer.visible = true
	$CanvasLayer/Credits.visible = false
	
	btnCredits.pressed.connect(onCreditsPressed)
	$CanvasLayer/Version.text = "Version: " + ProjectSettings.get_setting("application/config/version")
	
	btnPlay.pressed.connect(onPlayPressed)
	btnSettings.pressed.connect(onSettingsPressed)
	btnQuit.pressed.connect(onQuitPressed)
	
	showSettings(false)
	settings.btnClose.pressed.connect(onSettingsBackPressed)
	btnPlay.grab_focus()
	
	labelArt.meta_clicked.connect(handleRichTextMetaClick)
	labelSound.meta_clicked.connect(handleRichTextMetaClick)
	labelMusic.meta_clicked.connect(handleRichTextMetaClick)

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

func showSettings(_show: bool) -> void:
	if _show:
		settings.btnClose.grab_focus()
	else:
		btnSettings.grab_focus()
	
	#pauseButtons.visible = !_show
	btnCredits.disabled = _show
	btnCredits.focus_mode = Control.FOCUS_NONE if _show else Control.FOCUS_ALL
	settings.visible = _show

# Main Menu
func onPlayPressed() -> void:
	playClickSound()
	get_tree().change_scene_to_packed(levelScene)

func onSettingsPressed() -> void:
	playClickSound()
	showSettings(true)

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()

func onSettingsBackPressed() -> void:
	playClickSound()
	showSettings(false)

# Credits Menu
func handleRichTextMetaClick(meta: Variant) -> void:
	OS.shell_open(str(meta))

func onCreditsPressed() -> void:
	playClickSound()
	if !creditsToggle:
		$CanvasLayer/VBoxContainer.visible = false
		$CanvasLayer/Credits.visible = true
		creditsToggle = true
	else:
		$CanvasLayer/VBoxContainer.visible = true
		$CanvasLayer/Credits.visible = false
		creditsToggle = false
