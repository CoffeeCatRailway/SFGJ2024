extends Control

@onready var keybindButtonScene: PackedScene = preload("res://scenes/elements/ui/keybind_button.tscn")

@export var actionContainer: VBoxContainer
@export var btnReset: Button

@export var btnKeybinds: Node

var isRemapping: bool = false
var actionToRemap: String = ""
var remappingButton: Button = null

var actionNames: Dictionary = {
	"move_up": "Move Up",
	"move_down": "Move Down",
	"move_left": "Move Left",
	"move_right": "Move Right",
	"run": "Run",
	"fire": "Fire",
	"pause": "Pause",
}

var regex: RegEx

func _ready() -> void:
	loadKeyBindingsFromSave()
	createActionList()
	
	btnReset.pressed.connect(onResetPressed)

func loadKeyBindingsFromSave() -> void:
	#InputMap.load_from_project_settings()
	var keyBindings: Dictionary = SaveManager.loadKeybindings()
	for action: String in keyBindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keyBindings[action])

func createActionList() -> void:
	for child: Control in actionContainer.get_children():
		child.queue_free()
	
	for action: String in actionNames.keys():
		var button: Button = keybindButtonScene.instantiate()
		var labelName: Label = button.find_child("ActionName")
		var labelKey: Label = button.find_child("ActionKey")
		
		labelName.text = actionNames[action]
		
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		if events.size() > 0:
			labelKey.text = trimActionName(events[0].as_text())
			SaveManager.saveKeybind(action, events[0])
		else:
			labelKey.text = "NaN"
		
		actionContainer.add_child(button)
		button.pressed.connect(onKeybindButtonPressed.bind(button, action))
		#button.focus_neighbor_top = button.get_path_to(btnKeybinds)
	
	# Oath is relative to button
	actionContainer.get_child(0).focus_neighbor_top = actionContainer.get_child(0).get_path_to(btnKeybinds)

func onKeybindButtonPressed(button: Button, action: String) -> void:
	if !isRemapping:
		isRemapping = true
		actionToRemap = action
		remappingButton = button
		
		button.find_child("ActionKey").text = "Press key..."

func _input(event: InputEvent) -> void:
	if !isRemapping:
		return
	
	if event is InputEventKey || (event is InputEventMouseButton && event.is_pressed()):# || event is InputEventJoypadButton:
		if event is InputEventMouseButton && event.double_click:
			event.double_click = false
		
		InputMap.action_erase_events(actionToRemap)
		InputMap.action_add_event(actionToRemap, event)
		
		remappingButton.find_child("ActionKey").text = trimActionName(event.as_text())
		SaveManager.saveKeybind(actionToRemap, event)
		
		isRemapping = false
		actionToRemap = ""
		remappingButton = null
		
		accept_event()

func trimActionName(action: String) -> String:
	if !regex:
		regex = RegEx.new()
		regex.compile("^([^\\(]*)")
	return regex.search(action).get_string()

func onResetPressed() -> void:
	loadKeyBindingsFromSave()
	createActionList()
