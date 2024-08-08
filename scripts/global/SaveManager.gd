extends Node

const SAVE_PATH: String = "user://settings.ini"
const SAVE_PATH_DEFAULT: String = "user://settings-default.ini"
const SAVED_ACTIONS: Array[String] = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
	"run",
	"fire",
	"pause"
]

var AUDIO_BUS_NAMES: Array[String] = []:
	get:
		if AUDIO_BUS_NAMES.is_empty():
			for i: int in AudioServer.bus_count:
				AUDIO_BUS_NAMES.append(AudioServer.get_bus_name(i).to_lower())
		return AUDIO_BUS_NAMES

var configFile: ConfigFile = ConfigFile.new()
var configFileDefault: ConfigFile:
	get:
		if !configFileDefault:
			configFileDefault = ConfigFile.new()
			var result: Error = configFileDefault.load(SAVE_PATH_DEFAULT)
			if result != OK:
				printerr("Unable to load default settings! Error code: ", result)
				return null
		return configFileDefault

func _enter_tree() -> void:
	var result: Error = configFile.load(SAVE_PATH)
	
	if result != OK:
		configFile.set_value("stats", "kills", 0)
		configFile.set_value("stats", "time", -1)
		
		configFile.set_value("volume", "master", db_to_linear(AudioServer.get_bus_volume_db(0)))
		configFile.set_value("volume", "sfx", db_to_linear(AudioServer.get_bus_volume_db(1)))
		configFile.set_value("volume", "music", db_to_linear(AudioServer.get_bus_volume_db(2)))
		configFile.set_value("volume", "menu", db_to_linear(AudioServer.get_bus_volume_db(3)))
		
		InputMap.load_from_project_settings()
		for action: String in SAVED_ACTIONS:
			var events: Array[InputEvent] = InputMap.action_get_events(action)
			var value: String = ""
			if events.size() > 0:
				value = getKeybindFromEvent(events[0])
			configFile.set_value("keybinds", action, value)
		
		save()
		save(SAVE_PATH_DEFAULT)

func _exit_tree() -> void:
	save()

func save(path: String = SAVE_PATH) -> void:
	var result: Error = configFile.save(path)
	if result != OK:
		printerr("Save failed! Error code: ", result)
	#else:
		#print("Saved!")

func saveStatKills(kills: int) -> void:
	configFile.set_value("stats", "kills", kills)
	save()

func loadStatKills(useDefault: bool = false) -> int:
	var configFile: ConfigFile = configFileDefault if useDefault else self.configFile
	return int(configFile.get_value("stats", "kills", 0))

func saveStatTime(time: int) -> void:
	configFile.set_value("stats", "time", time)
	save()

func loadStatTime(useDefault: bool = false) -> int:
	var configFile: ConfigFile = configFileDefault if useDefault else self.configFile
	return int(configFile.get_value("stats", "time", -1))

func saveVolume(busName: String, volume: float) -> void:
	if !AUDIO_BUS_NAMES.has(busName):
		printerr("Audio bus '%s' does not exist!" % busName)
		return
	
	configFile.set_value("volume", busName, volume)
	save()

func loadVolume(busName: String, useDefault: bool = false) -> float:
	if !AUDIO_BUS_NAMES.has(busName):
		printerr("Audio bus '%s' does not exist!" % busName)
		return -1.
	
	var configFile: ConfigFile = configFileDefault if useDefault else self.configFile
	return float(configFile.get_value("volume", busName, 1.))

func getKeybindFromEvent(event: InputEvent) -> String:
	if event is InputEventKey:
		var physical: String = OS.get_keycode_string(event.physical_keycode)
		if physical != "":
			return physical
		return OS.get_keycode_string(event.keycode)
	elif event is InputEventMouseButton:
		return "mouse_" + str(event.button_index)
	elif event is InputEventJoypadButton:
		return "joypad_button_" + str(event.button_index)
	elif event is InputEventJoypadMotion:
		return "joypad_axis_" + str(event.axis) + "_" + str(signf(event.axis_value))
	return OS.get_keycode_string(KEY_NONE)

func saveKeybind(action: String, event: InputEvent) -> void:
	if !SAVED_ACTIONS.has(action):
		printerr("Keybind action '%s' does not exist!" % action)
		return
	
	configFile.set_value("keybinds", action, getKeybindFromEvent(event))
	save()
#
func loadKeybindings(useDefault: bool = false) -> Dictionary:
	var configFile: ConfigFile = configFileDefault if useDefault else self.configFile
	var keybindings: Dictionary = {}
	for action: String in configFile.get_section_keys("keybinds"):
		var event: InputEvent
		var keybind: String = configFile.get_value("keybinds", action, "")
		
		if keybind.begins_with("joypad_axis_"):
			event = InputEventJoypadMotion.new()
			var axis: PackedFloat64Array = keybind.trim_prefix("joypad_axis_").split_floats("_")
			event.axis = int(axis[0])
			event.axis_value = axis[1]
		elif keybind.begins_with("joypad_button_"):
			event = InputEventJoypadButton.new()
			event.button_index = int(keybind.trim_prefix("joypad_button_"))
		elif keybind.begins_with("mouse_"):
			event = InputEventMouseButton.new()
			event.button_index = int(keybind.trim_prefix("mouse_"))
		else:
			event = InputEventKey.new()
			event.keycode = OS.find_keycode_from_string(keybind)
			event.physical_keycode = event.keycode
		
		keybindings[action] = event
	return keybindings
