extends Node

const SAVE_PATH: String = "user://settings.tres"
var saveResource: SaveResource
var newSave: bool = false

func _ready() -> void:
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
