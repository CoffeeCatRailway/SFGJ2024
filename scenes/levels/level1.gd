extends Node2D

func _ready() -> void:
	StatTracker.resetCurrent()
	StatTracker.start()
	
	PauseMenu.canPause = true
