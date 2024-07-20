extends Node

var kills: int = 0
var startTime: int = -1

func _ready() -> void:
	reset()

func reset() -> void:
	kills = 0
	startTime = -1

func start() -> void:
	startTime = Time.get_ticks_msec()

func stop() -> String:
	var time: int = Time.get_ticks_msec() - startTime
	var minutes: int = int(time / 60 / 1000)
	var seconds: int = int(time / 1000) % 60
	var miliseconds: int = time % 1000
	return "%02d.%02d.%03d" % [minutes, seconds, miliseconds]
