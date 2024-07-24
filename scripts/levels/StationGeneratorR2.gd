extends Node

const ROOMS: Dictionary = {
	"end_north": {
		"id": 1,
		"entrances": 0b1000
	},
	"end_south": {
		"id": 2,
		"entrances": 0b0100
	},
	"end_east": {
		"id": 3,
		"entrances": 0b0010
	},
	"end_west": {
		"id": 4,
		"entrances": 0b0001
	},
	"straight_horizontal": {
		"id": 5,
		"entrances": 0b0011
	},
	"straight_vertical": {
		"id": 6,
		"entrances": 0b1100
	},
	"intersection_cross": {
		"id": 7,
		"entrances": 0b1111
	},
	"intersection_north": {
		"id": 8,
		"entrances": 0b1011
	},
	"intersection_south": {
		"id": 9,
		"entrances": 0b0111
	},
	"intersection_east": {
		"id": 10,
		"entrances": 0b1110
	},
	"intersection_west": {
		"id": 11,
		"entrances": 0b1101
	},
	"corner_north_east": {
		"id": 12,
		"entrances": 0b1010
	},
	"corner_north_west": {
		"id": 13,
		"entrances": 0b1001
	},
	"corner_south_east": {
		"id": 14,
		"entrances": 0b0110
	},
	"corner_south_west": {
		"id": 15,
		"entrances": 0b0101
	}
}
var ROOMS_KEYS: Array:#[String]:
	get:
		if !ROOMS_KEYS:
			ROOMS_KEYS = ROOMS.keys().duplicate()
		ROOMS_KEYS.shuffle()
		return ROOMS_KEYS
var ROOMS_KEYS_ENDS: Array:#[String]:
	get:
		if !ROOMS_KEYS_ENDS:
			ROOMS_KEYS_ENDS = ROOMS.keys().filter(func(key: String) -> bool: return key.begins_with("end_")).duplicate()
		ROOMS_KEYS_ENDS.shuffle()
		return ROOMS_KEYS_ENDS

const BIT_NORTH: int = 0b1000
const BIT_SOUTH: int = 0b0100
const BIT_EAST: int = 0b0010
const BIT_WEST: int = 0b0001
const BIT_ALL_OPEN: int = 0b1111
const BIT_ALL_CLOSED: int = 0b0000

signal testSignal

@export var roomMap: TileMap
@export_range(1, 100, 1) var maxRooms: int = 20

# {
# 	(0, 0): {
# 		"entrances": 0b1111
# 		"entrances_open": 0b1111
# 	}
# }
var roomsPlaced: Dictionary = {}
var roomsToCheck: Array[Vector2i] = []

func _ready() -> void:
	#seed(0)
	#setRoom(Vector2i(1, 0), "corner_north_west")
	#setRoom(Vector2i(1, -1), "straight_vertical")
	setRoom(Vector2i.ZERO, "intersection_cross")
	roomsToCheck.append(Vector2i.ZERO)
	call_deferred("generate")

func generate() -> void:
	#await get_tree().physics_frame
	var timeStart: int = Time.get_ticks_msec()
	
	while roomsToCheck.size() > 0 && roomsPlaced.size() <= maxRooms:
		# Get initial variables
		var roomPos: Vector2i = roomsToCheck[0]
		print(roomPos)
		
		if tryPlaceRoom(roomPos, roomPos + Vector2i.UP, BIT_NORTH, BIT_SOUTH):
			roomsToCheck.append(roomPos + Vector2i.UP)
		if tryPlaceRoom(roomPos, roomPos + Vector2i.DOWN, BIT_SOUTH, BIT_NORTH):
			roomsToCheck.append(roomPos + Vector2i.DOWN)
		if tryPlaceRoom(roomPos, roomPos + Vector2i.RIGHT, BIT_EAST, BIT_WEST):
			roomsToCheck.append(roomPos + Vector2i.RIGHT)
		if tryPlaceRoom(roomPos, roomPos + Vector2i.LEFT, BIT_WEST, BIT_EAST):
			roomsToCheck.append(roomPos + Vector2i.LEFT)
		
		roomsToCheck.remove_at(0)
		await get_tree().create_timer(.01).timeout
		#await testSignal
	
	print("Rooms left to check: ", roomsToCheck.size())#, " ", roomsToCheck)
	var checkEndRooms: Array[Vector2i] = roomsToCheck.filter(func(pos: Vector2i) -> bool:
		for key: String in ROOMS_KEYS_ENDS:
			if roomsPlaced[pos]["entrances"] == ROOMS[key]["entrances"]:
				return true
		return false)
	for pos in roomsToCheck:
		roomMap.set_cell(1, pos, 4, Vector2i(1, 0))
	#for pos in roomsToCheck.filter(func(pos: Vector2i) -> bool: return roomsPlaced[pos]["entrances_open"] != BIT_ALL_CLOSED):
		#roomMap.set_cell(1, pos, 4, Vector2i(0, 1))
	for pos in checkEndRooms:
		roomMap.set_cell(1, pos, 4, Vector2i.ZERO)
	
	print("Station generation took %sms" % (Time.get_ticks_msec() - timeStart))
	print("Total room count: ", roomsPlaced.size())

func tryPlaceRoom(parentPos: Vector2i, pos: Vector2i, entrance: int, entranceOpposite: int) -> bool:
	var entrances: int = roomsPlaced[parentPos]["entrances"]
	var entrancesStillOpen: int = roomsPlaced[parentPos]["entrances_open"]
	if entrances & entrance && entrancesStillOpen & entrance:
		var finalRooms: bool = roomsPlaced.size() >= maxRooms - 8
		var openEntrances: int = getOpenEntrances(pos, !finalRooms)
		
		for key: String in ROOMS_KEYS:
			var possibleRoomEntrances: int = ROOMS[key]["entrances"]
			
			if finalRooms:
				if possibleRoomEntrances != openEntrances:
					continue
				
				setRoom(pos, key)
				#entrancesStillOpen ^= entrance # Set entrances closed
				roomsPlaced[parentPos]["entrances_open"] ^= entrance
				return true
			else:
				var noEntranceSkip: bool = possibleRoomEntrances & entranceOpposite == 0 # Skips if doesn't join
				var wallSkip: bool = possibleRoomEntrances & (~openEntrances) # Skips if leads to wall
				if noEntranceSkip || wallSkip || roomsPlaced.has(pos):
					continue
				
				setRoom(pos, key)
				#entrancesStillOpen ^= entrance # Set entrances closed
				roomsPlaced[parentPos]["entrances_open"] ^= entrance
				return true
	return false

func _process(_delta: float) -> void:
	pass
	if Input.is_action_just_pressed("ui_down"):
		testSignal.emit()

func getOpenEntrances(roomPos: Vector2i, includeEmptySpaces: bool = true) -> int:
	var roomByte: int = BIT_ALL_CLOSED
	
	var north: Dictionary = roomsPlaced.get(roomPos + Vector2i.UP, {})
	if north.is_empty() && includeEmptySpaces:
		roomByte |= BIT_NORTH
	elif !north.is_empty() && north["entrances_open"] & BIT_SOUTH:
		roomByte |= BIT_NORTH
	
	#if (north.is_empty() && includeEmptySpaces) || north["entrances_open"] & BIT_SOUTH:
		#roomByte |= BIT_NORTH
	
	var south: Dictionary = roomsPlaced.get(roomPos + Vector2i.DOWN, {})
	if south.is_empty() && includeEmptySpaces:
		roomByte |= BIT_SOUTH
	elif !south.is_empty() && south["entrances_open"] & BIT_NORTH:
		roomByte |= BIT_SOUTH
	
	#if (south.is_empty() && includeEmptySpaces) || south["entrances_open"] & BIT_NORTH:
		#roomByte |= BIT_SOUTH
	
	var east: Dictionary = roomsPlaced.get(roomPos + Vector2i.RIGHT, {})
	if east.is_empty() && includeEmptySpaces:
		roomByte |= BIT_EAST
	elif !east.is_empty() && east["entrances_open"] & BIT_WEST:
		roomByte |= BIT_EAST
	
	#if (east.is_empty() && includeEmptySpaces) || east["entrances_open"] & BIT_WEST:
		#roomByte |= BIT_EAST
	
	var west: Dictionary = roomsPlaced.get(roomPos + Vector2i.LEFT, {})
	if west.is_empty() && includeEmptySpaces:
		roomByte |= BIT_WEST
	elif !west.is_empty() && west["entrances_open"] & BIT_EAST:
		roomByte |= BIT_WEST
	
	#if (west.is_empty() && includeEmptySpaces) || west["entrances_open"] & BIT_EAST:
		#roomByte |= BIT_WEST
	
	return roomByte

func setRoom(coords: Vector2i, room: String) -> bool:
	if roomsPlaced.has(coords):
		return false
	
	roomMap.set_cell(0, coords, 3, Vector2i.ZERO, ROOMS[room]["id"])
	roomsPlaced[coords] = {"entrances": ROOMS[room]["entrances"], "entrances_open": ROOMS[room]["entrances"]}
	return true

func dec2bin(decimal_value: int, count: int = 4) -> String:
	var binary_string: String = ""
	var temp: int
	#var count = 7 # Checking up to 8 bits
	count -= 1
	
	while(count >= 0):
		temp = decimal_value >> count
		if(temp & 1):
			binary_string = binary_string + "1"
		else:
			binary_string = binary_string + "0"
		count -= 1
	
	return binary_string




