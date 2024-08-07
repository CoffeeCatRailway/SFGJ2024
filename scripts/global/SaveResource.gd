class_name SaveResource
extends Resource

@export var bestKills: int = 0
@export var bestTime: int = -1

@export_range(0., 1.) var masterVolume: float = .963
@export_range(0., 1.) var effectsVolume: float = .33
@export_range(0., 1.) var musicVolume: float = .186
@export_range(0., 1.) var menuVolume: float = .314

@export var keyBinds: Dictionary = {
	"move_up": "W",
	"move_down": "S",
	"move_left": "A",
	"move_right": "D",
	"run": "Ctrl",
	"fire": "mouse_1",
	"pause": "Escape",
}

# Default system values
func _init() -> void:
	masterVolume = db_to_linear(AudioServer.get_bus_volume_db(0))
	effectsVolume = db_to_linear(AudioServer.get_bus_volume_db(1))
	musicVolume = db_to_linear(AudioServer.get_bus_volume_db(2))
	menuVolume = db_to_linear(AudioServer.get_bus_volume_db(3))
