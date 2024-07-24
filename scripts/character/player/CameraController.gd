extends Camera2D

@export var roomMap: TileMap

func _process(delta):
	global_position = roomMap.map_to_local(roomMap.local_to_map(%Player.global_position))
