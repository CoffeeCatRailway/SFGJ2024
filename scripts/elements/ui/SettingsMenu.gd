class_name SettingsMenu
extends Panel

@export var audioPlayer: AudioStreamPlayer
@export var clickSound: AudioStream

@onready var btnClose: Button = $BtnClose
@onready var btnAudio: Button = $BtnAudio
@onready var btnKeybinds: Button = $BtnKeybinds

@onready var audio: Panel = $Audio
@onready var keybinds: Panel = $Keybinds

func _ready() -> void:
	#btnClose.grab_focus()
	
	btnAudio.pressed.connect(onAudioPressed)
	btnKeybinds.pressed.connect(onKeybindsPressed)

func onAudioPressed() -> void:
	btnAudio.disabled = true
	btnKeybinds.disabled = false
	btnKeybinds.button_pressed = false
	
	audio.visible = true
	keybinds.visible = false
	playClickSound()

func onKeybindsPressed() -> void:
	btnKeybinds.disabled = true
	btnAudio.disabled = false
	btnAudio.button_pressed = false
	
	audio.visible = false
	keybinds.visible = true
	keybinds.createActionList()
	playClickSound()

func playClickSound() -> void:
	if !audioPlayer:
		return
	audioPlayer.stream = clickSound
	audioPlayer.play()
