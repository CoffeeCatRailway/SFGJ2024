extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@export var clickSound: AudioStream

@export var winColor: Color
@export var loseColor: Color

@onready var colorRect: ColorRect = $Control/ColorRect
@onready var label: Label = $Control/Label
@onready var statsLabel: Label = $Control/StatsLabel
@onready var statsBestLabel: Label = $Control/StatsBestLabel

@onready var btnPlay: Button = $Control/HBoxContainer/BtnPlay
@onready var btnQuit: Button = $Control/HBoxContainer/BtnQuit

func _ready() -> void:
	visible = false
	
	btnPlay.pressed.connect(onPlayPressed)
	btnQuit.pressed.connect(onQuitPressed)

func showMenu(won: bool) -> void:
	PauseMenu.canPause = false
	visible = true
	$AnimationPlayer.play("fade")
	var time: int = StatTracker.stop(won)
	statsLabel.text = "Kills: " + str(StatTracker.kills) + "  Time: " + StatTracker.getTimeString(time)
	statsBestLabel.text = "Most Kills: " + str(SaveManager.saveResource.bestKills) + "  Best Time: " + StatTracker.getTimeString(SaveManager.saveResource.bestTime)

func playClickSound() -> void:
	audioPlayer.stream = clickSound
	audioPlayer.play()

func winMenu() -> void:
	showMenu(true)
	colorRect.color = winColor
	label.text = "You Won"

func loseMenu() -> void:
	showMenu(false)
	colorRect.color = loseColor
	label.text = "You Died"

# Win
func onPlayPressed() -> void:
	playClickSound()
	visible = false
	get_tree().reload_current_scene()

func onQuitPressed() -> void:
	playClickSound()
	await audioPlayer.finished
	get_tree().quit()
