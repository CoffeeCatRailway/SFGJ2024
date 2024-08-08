extends Node

var kills: int = 0
var startTime: int = -1

func _ready() -> void:
	resetCurrent()

func resetCurrent() -> void:
	kills = 0
	startTime = -1

func addKill(amount: int = 1) -> void:
	kills += amount

func start() -> void:
	startTime = Time.get_ticks_msec()

func stop(gameWon: bool) -> int:
	var time: int = Time.get_ticks_msec() - startTime
	
	if gameWon:
		if kills > SaveManager.loadStatKills():
			SaveManager.saveStatKills(kills)
		var bestTime: int = SaveManager.loadStatTime()
		if time < bestTime || bestTime == -1:
			SaveManager.saveStatTime(time)
	
	return time

func getTimeString(time: int) -> String:
	var minutes: int = int(time / 60 / 1000)
	var seconds: int = int(time / 1000) % 60
	var miliseconds: int = time % 1000
	return "%02d.%02d.%03d" % [minutes, seconds, miliseconds]
