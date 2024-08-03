extends Control

@export var masterVolume: HSlider
@export var effectsVolume: HSlider
@export var musicVolume: HSlider
@export var menuVolume: HSlider

@export var btnReset: Button

func _ready() -> void:
	btnReset.pressed.connect(onResetPressed)
	
	#call_deferred("setVolumeSliders")
	setVolumeSliders()

func onResetPressed() -> void:
	var tempSave: SaveResource = SaveResource.new()
	masterVolume.value = tempSave.masterVolume
	effectsVolume.value = tempSave.effectsVolume
	musicVolume.value = tempSave.musicVolume
	menuVolume.value = tempSave.menuVolume

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
	if visible:
		setVolumes()
