extends Node

const SAVE_PATH: String = "user://settings.tres"
var saveResource: SaveResource
var newSave: bool = false

func _enter_tree() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		var loaded: Variant = ResourceLoader.load(SAVE_PATH)
		assert(loaded is SaveResource)
		saveResource = loaded as SaveResource
	else:
		saveResource = SaveResource.new()
		newSave = true

func _exit_tree() -> void:
	save()

func save() -> void:
	var result: Error = ResourceSaver.save(saveResource, SAVE_PATH)
	if result != OK:
		printerr("Save failed!")

func saveKeybind(action: String, event: InputEvent) -> void:
	if !saveResource.keyBinds.has(action):
		printerr("Keybind action %s does not exist!" % action)
		return
	
	if event is InputEventKey:
		SaveManager.saveResource.keyBinds[action] = OS.get_keycode_string(event.keycode)
	elif event is InputEventMouseButton:
		SaveManager.saveResource.keyBinds[action] = "mouse_" + str(event.button_index)
	elif event is InputEventJoypadButton:
		SaveManager.saveResource.keyBinds[action] = "joypad_button_" + str(event.button_index)
	elif event is InputEventJoypadMotion:
		SaveManager.saveResource.keyBinds[action] = "joypad_axis_" + str(event.axis) + "_" + str(signf(event.axis_value))
	
	save()

func loadKeybindings() -> Dictionary:
	var keyBindings: Dictionary = {}
	for action: String in saveResource.keyBinds.keys():
		var event: InputEvent
		var keyBind: String = saveResource.keyBinds[action]
		
		if keyBind.begins_with("joypad_axis_"):
			event = InputEventJoypadMotion.new()
			var axis: PackedFloat64Array = keyBind.trim_prefix("joypad_axis_").split_floats("_")
			event.axis = int(axis[0])
			event.axis_value = axis[1]
		elif keyBind.begins_with("joypad_button_"):
			event = InputEventJoypadButton.new()
			event.button_index = int(keyBind.trim_prefix("joypad_button_"))
		elif keyBind.begins_with("mouse_"):
			event = InputEventMouseButton.new()
			event.button_index = int(keyBind.trim_prefix("mouse_"))
		else:
			event = InputEventKey.new()
			event.keycode = OS.find_keycode_from_string(keyBind)
		
		keyBindings[action] = event
	return keyBindings
