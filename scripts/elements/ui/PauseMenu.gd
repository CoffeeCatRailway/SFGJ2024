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
@onready var settingsPanel: Panel = $Settings
@onready var masterVolume: HSlider = $Settings/Volumes/MasterVolume
@onready var effectsVolume: HSlider = $Settings/Volumes/EffectsVolume
@onready var musicVolume: HSlider = $Settings/Volumes/MusicVolume
@onready var menuVolume: HSlider = $Settings/Volumes/MenuVolume
@onready var btnSettingsBack: TextureButton = $Settings/BtnBack

# Set true in MainMenu
var canPause: bool = false

func _ready() -> void:
	visible = false
	showSettings(false)
	
	btnResume.pressed.connect(onResumePressed)
	btnSettings.pressed.connect(onSettingsPressed)
	btnMenu.pressed.connect(onMenuPressed)
	
	call_deferred("setVolumeSliders")
	btnSettingsBack.pressed.connect(onSettingsBackPressed)

func setVolumeSliders() -> void:
	if SaveManager.newSave:
		masterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
		effectsVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
		musicVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
		menuVolume.value = db_to_linear(AudioServer.get_bus_volume_db(3))
	else:
		masterVolume.value = SaveManager.saveResource.masterVolume
		effectsVolume.value = SaveManager.saveResource.effectsVolume
		musicVolume.value = SaveManager.saveResource.musicVolume
		menuVolume.value = SaveManager.saveResource.menuVolume
	setVolumes()

func setVolumes() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(masterVolume.value))
	#AudioServer.set_bus_mute(0, masterVolume.value < .001)
	AudioServer.set_bus_volume_db(1, linear_to_db(effectsVolume.value))
	#AudioServer.set_bus_mute(1, effectsVolume.value < .001)
	AudioServer.set_bus_volume_db(2, linear_to_db(musicVolume.value))
	#AudioServer.set_bus_mute(2, musicVolume.value < .001)
	AudioServer.set_bus_volume_db(3, linear_to_db(menuVolume.value))
	#AudioServer.set_bus_mute(3, menuVolume.value < .001)
	
	SaveManager.saveResource.masterVolume = masterVolume.value
	SaveManager.saveResource.effectsVolume = effectsVolume.value
	SaveManager.saveResource.musicVolume = musicVolume.value
	SaveManager.saveResource.menuVolume = menuVolume.value

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") && canPause:
		if pauseButtons.visible:
			pause(!visible)
		else:
			showSettings(false)
	
	if settingsPanel.visible:
		setVolumes()

func pause(p: bool) -> void:
	visible = p
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT if !visible else Node.PROCESS_MODE_DISABLED
	showSettings(false)

func showSettings(_show: bool) -> void:
	if _show:
		btnSettingsBack.grab_focus()
	else:
		btnResume.grab_focus()
	
	pauseButtons.visible = !_show
	settingsPanel.visible = _show

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
