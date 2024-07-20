extends Node2D

func _ready() -> void:
	StatTracker.reset()
	StatTracker.start()
	
	PauseMenu.canPause = true
