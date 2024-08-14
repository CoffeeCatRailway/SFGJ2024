extends Control

@export var masterVolume: HSlider
@export var effectsVolume: HSlider
@export var musicVolume: HSlider
@export var menuVolume: HSlider

@export var btnReset: Button

func _ready() -> void:
	masterVolume.value = SaveManager.loadVolume("master")
	effectsVolume.value = SaveManager.loadVolume("sfx")
	musicVolume.value = SaveManager.loadVolume("music")
	menuVolume.value = SaveManager.loadVolume("menu")
	setVolumes(0.)
	
	masterVolume.value_changed.connect(setVolumes)
	effectsVolume.value_changed.connect(setVolumes)
	musicVolume.value_changed.connect(setVolumes)
	menuVolume.value_changed.connect(setVolumes)
	
	btnReset.pressed.connect(onResetPressed)

func onResetPressed() -> void:
	masterVolume.value = SaveManager.loadVolume("master", true)
	effectsVolume.value = SaveManager.loadVolume("sfx", true)
	musicVolume.value = SaveManager.loadVolume("music", true)
	menuVolume.value = SaveManager.loadVolume("menu", true)
	print("Volumes reset")

func setVolumes(_v: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(masterVolume.value))
	AudioServer.set_bus_volume_db(1, linear_to_db(effectsVolume.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(musicVolume.value))
	AudioServer.set_bus_volume_db(3, linear_to_db(menuVolume.value))
	
	SaveManager.saveVolume("master", masterVolume.value)
	SaveManager.saveVolume("sfx", effectsVolume.value)
	SaveManager.saveVolume("music", musicVolume.value)
	SaveManager.saveVolume("menu", menuVolume.value)
