extends Node

const ROOMS_END: int = 0
const ROOMS_STRAIGHT: int = 1
const ROOMS_CORNER: int = 2

const ROOM_COLLECTION_LOOKUP: Dictionary = {
	ROOMS_END: ROOMS_END_KEYS,
	ROOMS_STRAIGHT: ROOMS_STRAIGHT_KEYS,
	ROOMS_CORNER: ROOMS_CORNER_KEYS
}

const ROOMS_END_KEYS: Dictionary = {
	"east-1": 1,
	"north-1": 2,
	"south-1": 3,
	"west-1": 4
}
const ROOMS_STRAIGHT_KEYS: Dictionary = {
	"horizontal-1": 1,
	"vertical-1": 2
}
const ROOMS_CORNER_KEYS: Dictionary = {
	"crossX-1": 1
}

const BIT_NORTH: int = 0b1000
const BIT_SOUTH: int = 0b0100
const BIT_EAST: int = 0b0010
const BIT_WEST: int = 0b0001

@export var roomMap: TileMap

var roomsToCheck: Dictionary = {}
var roomsPlaced: Dictionary = {}

func _ready() -> void:
	setRoom(Vector2i.ZERO, ROOMS_CORNER, "crossX-1")
	call_deferred("generate")

func getPlaceableRoomByte(roomPos: Vector2i) -> int:
	var roomByte: int = 0b0000
	
	var northByte: int = roomsPlaced.get(roomPos + Vector2i.UP, 0)
	if !northByte:
		roomByte |= BIT_NORTH
	elif northByte & BIT_SOUTH:
		roomByte |= BIT_SOUTH
	
	var southByte: int = roomsPlaced.get(roomPos + Vector2i.DOWN, 0)
	if !southByte:
		roomByte |= BIT_SOUTH
	elif southByte && southByte & BIT_NORTH:
		roomByte |= BIT_NORTH
	
	var eastByte: int = roomsPlaced.get(roomPos + Vector2i.RIGHT, 0)
	if !eastByte:
		roomByte |= BIT_EAST
	elif eastByte && eastByte & BIT_WEST:
		roomByte |= BIT_WEST
	
	var westByte: int = roomsPlaced.get(roomPos + Vector2i.LEFT, 0)
	if !westByte:
		roomByte |= BIT_WEST
	elif westByte && westByte & BIT_EAST:
		roomByte |= BIT_EAST
	
	return roomByte

signal testSignal

func roomByteToString(roomByte: int) -> String:
	var string: String = ""
	string += "-" if roomByte & BIT_NORTH else "_"
	string += "-" if roomByte & BIT_SOUTH else "_"
	string += "-" if roomByte & BIT_EAST else "_"
	string += "-" if roomByte & BIT_WEST else "_"
	return string

func generate() -> void:
	var timeStart: int = Time.get_ticks_msec()
	
	var crossXChance: float = .2
	var straightChance: float = .5
	
	while roomsToCheck.size() > 0:
		var roomKey: Vector2i = roomsToCheck.keys()[-1]
		print(roomKey)
		
		var roomByte: int = roomsToCheck[roomKey]
		var newRoomByte: int = roomByte
		
		#var randFloat: float = randf()
		
		if roomByte & BIT_NORTH:
			print("north")
			print(roomByteToString(getPlaceableRoomByte(roomKey + Vector2i.UP)))
			var canPlaceCrossX: bool = getPlaceableRoomByte(roomKey + Vector2i.UP) & (BIT_NORTH | BIT_EAST | BIT_WEST)
			var canPlaceVertical: bool = false && getPlaceableRoomByte(roomKey + Vector2i.UP) & BIT_NORTH
			#var canPlaceCrossX: bool = (roomsPlaced.get(roomKey + Vector2i.UP, BIT_SOUTH) & BIT_SOUTH) && (roomsPlaced.get(roomKey + Vector2i.UP, BIT_EAST) & BIT_EAST) && (roomsPlaced.get(roomKey + Vector2i.UP, BIT_WEST) & BIT_WEST)
			#var canPlaceVertical: bool = (roomsPlaced.get(roomKey + Vector2i.UP, BIT_NORTH) & BIT_NORTH) && (roomsPlaced.get(roomKey + Vector2i.UP, BIT_SOUTH) & BIT_SOUTH)
			
			if randf() < crossXChance && canPlaceCrossX:
				setRoom(roomKey + Vector2i.UP, ROOMS_CORNER, "crossX-1", BIT_SOUTH)
			elif randf() < straightChance && canPlaceVertical:
				setRoom(roomKey + Vector2i.UP, ROOMS_STRAIGHT, "vertical-1", BIT_SOUTH)
			else:
				setRoom(roomKey + Vector2i.UP, ROOMS_END, "south-1", BIT_SOUTH)
			newRoomByte = roomByte ^ BIT_NORTH
		elif roomByte & BIT_SOUTH:
			print("south")
			var canPlaceCrossX: bool = getPlaceableRoomByte(roomKey + Vector2i.DOWN) & (BIT_SOUTH | BIT_EAST | BIT_WEST)
			var canPlaceVertical: bool = false && getPlaceableRoomByte(roomKey + Vector2i.DOWN) & BIT_SOUTH
			#var canPlaceCrossX: bool = (roomsPlaced.get(roomKey + Vector2i.DOWN, BIT_NORTH) & BIT_NORTH) && (roomsPlaced.get(roomKey + Vector2i.DOWN, BIT_EAST) & BIT_EAST) && (roomsPlaced.get(roomKey + Vector2i.DOWN, BIT_WEST) & BIT_WEST)
			#var canPlaceVertical: bool = (roomsPlaced.get(roomKey + Vector2i.DOWN, BIT_NORTH) & BIT_NORTH) && (roomsPlaced.get(roomKey + Vector2i.DOWN, BIT_SOUTH) & BIT_SOUTH)
			
			if randf() < crossXChance && canPlaceCrossX:
				setRoom(roomKey + Vector2i.DOWN, ROOMS_CORNER, "crossX-1", BIT_NORTH)
			elif randf() < straightChance && canPlaceVertical:
				setRoom(roomKey + Vector2i.DOWN, ROOMS_STRAIGHT, "vertical-1", BIT_NORTH)
			else:
				setRoom(roomKey + Vector2i.DOWN, ROOMS_END, "north-1", BIT_NORTH)
			newRoomByte = roomByte ^ BIT_SOUTH
		elif roomByte & BIT_EAST:
			print("east")
			var canPlaceCrossX: bool = getPlaceableRoomByte(roomKey + Vector2i.RIGHT) & (BIT_NORTH | BIT_SOUTH | BIT_EAST)
			var canPlaceHorizontal: bool = false && getPlaceableRoomByte(roomKey + Vector2i.RIGHT) & BIT_EAST
			#var canPlaceCrossX: bool = (roomsPlaced.get(roomKey + Vector2i.RIGHT, BIT_NORTH) & BIT_NORTH) && (roomsPlaced.get(roomKey + Vector2i.RIGHT, BIT_SOUTH) & BIT_SOUTH) && (roomsPlaced.get(roomKey + Vector2i.RIGHT, BIT_WEST) & BIT_WEST)
			#var canPlaceHorizontal: bool = (roomsPlaced.get(roomKey + Vector2i.RIGHT, BIT_EAST) & BIT_EAST) && (roomsPlaced.get(roomKey + Vector2i.RIGHT, BIT_WEST) & BIT_WEST)
			
			if randf() < crossXChance && canPlaceCrossX:
				setRoom(roomKey + Vector2i.RIGHT, ROOMS_CORNER, "crossX-1", BIT_WEST)
			elif randf() < straightChance && canPlaceHorizontal:
				setRoom(roomKey + Vector2i.RIGHT, ROOMS_STRAIGHT, "horizontal-1", BIT_WEST)
			else:
				setRoom(roomKey + Vector2i.RIGHT, ROOMS_END, "west-1", BIT_WEST)
			newRoomByte = roomByte ^ BIT_EAST
		elif roomByte & BIT_WEST:
			print("west")
			var canPlaceCrossX: bool = getPlaceableRoomByte(roomKey + Vector2i.LEFT) & (BIT_NORTH | BIT_SOUTH | BIT_WEST)
			var canPlaceHorizontal: bool = false && getPlaceableRoomByte(roomKey + Vector2i.LEFT) & BIT_WEST
			#var canPlaceCrossX: bool = (roomsPlaced.get(roomKey + Vector2i.LEFT, BIT_NORTH) & BIT_NORTH) && (roomsPlaced.get(roomKey + Vector2i.LEFT, BIT_SOUTH) & BIT_SOUTH) && (roomsPlaced.get(roomKey + Vector2i.LEFT, BIT_EAST) & BIT_EAST)
			#var canPlaceHorizontal: bool = (roomsPlaced.get(roomKey + Vector2i.LEFT, BIT_EAST) & BIT_EAST) && (roomsPlaced.get(roomKey + Vector2i.LEFT, BIT_WEST) & BIT_WEST)
			
			if randf() < crossXChance && canPlaceCrossX:
				setRoom(roomKey + Vector2i.LEFT, ROOMS_CORNER, "crossX-1", BIT_EAST)
			elif randf() < straightChance && canPlaceHorizontal:
				setRoom(roomKey + Vector2i.LEFT, ROOMS_STRAIGHT, "horizontal-1", BIT_EAST)
			else:
				setRoom(roomKey + Vector2i.LEFT, ROOMS_END, "east-1", BIT_EAST)
			newRoomByte = roomByte ^ BIT_WEST
		
		if newRoomByte != roomByte:
			roomsToCheck[roomKey] = newRoomByte
			#roomsPlaced[roomKey] = newRoomByte
		if newRoomByte == 0:
			roomsToCheck.erase(roomKey)
		await get_tree().create_timer(.1).timeout
		#await testSignal
	
	print("Station generation took %sms" % (Time.get_ticks_msec() - timeStart))
	print("Total room count: ", roomsPlaced.size())

func _process(_delta: float) -> void:
	pass
	if Input.is_action_just_pressed("ui_down"):
		testSignal.emit()

func setRoom(coords: Vector2i, collection: int, room: String, roomByteOverride: int = 0b0000) -> bool:
	if roomsPlaced.has(coords):
		return false
	
	roomMap.set_cell(0, coords, collection, Vector2i.ZERO, ROOM_COLLECTION_LOOKUP[collection][room])
	roomsToCheck[coords] = generateRoomByte(room) ^ roomByteOverride
	roomsPlaced[coords] = generateRoomByte(room)#roomsToCheck[coords]
	return true

func generateRoomByte(roomKey: String) -> int:
	var bitKey: int = 0b0000 # 0
	for part: String in roomKey.split("-"):
		match part:
			"north":
				bitKey |= 0b1000
			"south":
				bitKey |= 0b0100
			"east":
				bitKey |= 0b0010
			"west":
				bitKey |= 0b0001
			"horizontal":
				bitKey |= 0b0011
			"vertical":
				bitKey |= 0b1100
			"crossX":
				#bitKey |= 0b1111
				bitKey = 15
			_:
				pass
	return bitKey












