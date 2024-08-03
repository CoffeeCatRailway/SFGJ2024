extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

# Pause Menu
@onready var pauseButtons: VBoxContainer = $PauseButtons
@onready var btnResume: Button = $PauseButtons/BtnResume
@onready var btnSettings: Button = $PauseButtons/BtnSettings

@export var menuScene: PackedScene = preload("res://scenes/elements/ui/main_menu.tscn")
@onready var btnMenu: Button = $PauseButtons/BtnMenu

# Settings Menu
@onready var settings: SettingsMenu = $SettingsMenu

# Set true in MainMenu
var canPause: bool = false

func _ready() -> void:
	visible = false
	showSettings(false)
	
	btnResume.pressed.connect(onResumePressed)
	btnSettings.pressed.connect(onSettingsPressed)
	btnMenu.pressed.connect(onMenuPressed)
	
	settings.btnClose.pressed.connect(onSettingsBackPressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") && canPause:
		if pauseButtons.visible:
			pause(!visible)
		else:
			showSettings(false)

func pause(p: bool) -> void:
	visible = p
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT if !visible else Node.PROCESS_MODE_DISABLED
	showSettings(false)

func showSettings(_show: bool) -> void:
	if _show:
		settings.btnClose.grab_focus()
	else:
		btnSettings.grab_focus()
	
	pauseButtons.visible = !_show
	settings.visible = _show

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

# Pause Buttons
func onResumePressed() -> void:
	playClickSound()
	pause(false)

func onSettingsPressed() -> void:
	playClickSound()
	showSettings(true)

func onMenuPressed() -> void:
	playClickSound()
	pause(false)
	get_tree().change_scene_to_packed(menuScene)

# Settings
func onSettingsBackPressed() -> void:
	playClickSound()
	showSettings(false)
