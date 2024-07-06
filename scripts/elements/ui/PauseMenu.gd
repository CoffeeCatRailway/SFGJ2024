extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

# Pause Menu
@onready var pauseButtons: VBoxContainer = $PauseButtons
@onready var btnResume: Button = $PauseButtons/BtnResume
@onready var btnSettings: Button = $PauseButtons/BtnSettings
@onready var btnQuit: Button = $PauseButtons/BtnQuit

# Settings Menu
@onready var settingsPanel: Panel = $Settings
@onready var masterVolume: HSlider = $Settings/Volumes/MasterVolume
@onready var effectsVolume: HSlider = $Settings/Volumes/EffectsVolume
@onready var musicVolume: HSlider = $Settings/Volumes/MusicVolume
@onready var menuVolume: HSlider = $Settings/Volumes/MenuVolume
@onready var btnSettingsBack: TextureButton = $Settings/BtnBack

func _ready() -> void:
	visible = false
	showSettings(false)
	
	btnResume.pressed.connect(onResumePressed)
	btnSettings.pressed.connect(onSettingsPressed)
	btnQuit.pressed.connect(onQuitPressed)
	
	masterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	effectsVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	musicVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	menuVolume.value = db_to_linear(AudioServer.get_bus_volume_db(3))
	btnSettingsBack.pressed.connect(onSettingsBackPressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if pauseButtons.visible:
			pause(!visible)
		else:
			showSettings(false)
	
	if settingsPanel.visible:
		AudioServer.set_bus_volume_db(0, linear_to_db(masterVolume.value))
		#AudioServer.set_bus_mute(0, masterVolume.value < .001)
		AudioServer.set_bus_volume_db(1, linear_to_db(effectsVolume.value))
		#AudioServer.set_bus_mute(1, effectsVolume.value < .001)
		AudioServer.set_bus_volume_db(2, linear_to_db(musicVolume.value))
		#AudioServer.set_bus_mute(2, musicVolume.value < .001)
		AudioServer.set_bus_volume_db(3, linear_to_db(menuVolume.value))
		#AudioServer.set_bus_mute(3, menuVolume.value < .001)

func pause(p: bool) -> void:
	visible = p
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT if !visible else Node.PROCESS_MODE_DISABLED

func showSettings(show: bool) -> void:
	pauseButtons.visible = !show
	settingsPanel.visible = show

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

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()

# Settings
func onSettingsBackPressed() -> void:
	playClickSound()
	showSettings(false)
