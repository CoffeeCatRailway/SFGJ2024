extends Node

const RULE_WALL: int = 0
const RULE_DOOR: int = 1
#const RULE_COMBINE: int = 2

const WEIGHT_EMPTY: int = 10
const WEIGHT_END: int = 6
const WEIGHT_STRAIGHT: int = 5
const WEIGHT_CORNER: int = 5
const WEIGHT_INTERSECTION: int = 4
#const WEIGHT_MISC: int = 1

const ROOMS: Dictionary = {
	"empty": {
		"id": -1,
		# North East South West
		"rules": [RULE_WALL, RULE_WALL, RULE_WALL, RULE_WALL],
		"weight": WEIGHT_EMPTY
	},
	#"empty1": {
		#"id": -1,
		## North East South West
		#"rules": [RULE_WALL, RULE_WALL, RULE_WALL, RULE_COMBINE],
		#"weight": WEIGHT_EMPTY
	#},
	#"empty2": {
		#"id": -1,
		## North East South West
		#"rules": [RULE_WALL, RULE_COMBINE, RULE_WALL, RULE_WALL],
		#"weight": WEIGHT_EMPTY
	#},
	#"empty3": {
		#"id": -1,
		## North East South West
		#"rules": [RULE_COMBINE, RULE_WALL, RULE_WALL, RULE_WALL],
		#"weight": WEIGHT_EMPTY
	#},
	#"empty4": {
		#"id": -1,
		## North East South West
		#"rules": [RULE_WALL, RULE_WALL, RULE_COMBINE, RULE_WALL],
		#"weight": WEIGHT_EMPTY
	#},
	"end_north": {
		"id": 1,
		"rules": [RULE_DOOR, RULE_WALL, RULE_WALL, RULE_WALL],
		"weight": WEIGHT_END
	},
	"end_south": {
		"id": 2,
		"rules": [RULE_WALL, RULE_WALL, RULE_DOOR, RULE_WALL],
		"weight": WEIGHT_END
	},
	"end_east": {
		"id": 3,
		"rules": [RULE_WALL, RULE_DOOR, RULE_WALL, RULE_WALL],
		"weight": WEIGHT_END
	},
	"end_west": {
		"id": 4,
		"rules": [RULE_WALL, RULE_WALL, RULE_WALL, RULE_DOOR],
		"weight": WEIGHT_END
	},
	"straight_horizontal": {
		"id": [5, 19],
		"id-weights": [1, 0],
		"rules": [RULE_WALL, RULE_DOOR, RULE_WALL, RULE_DOOR],
		"weight": WEIGHT_STRAIGHT
	},
	"straight_vertical": {
		"id": 6,
		"rules": [RULE_DOOR, RULE_WALL, RULE_DOOR, RULE_WALL],
		"weight": WEIGHT_STRAIGHT
	},
	#"intersection_cross": {
		#"id": 7,
		#"rules": [RULE_DOOR, RULE_DOOR, RULE_DOOR, RULE_DOOR],
		#"weight": WEIGHT_MISC
	#},
	"intersection_north": {
		"id": 8,
		"rules": [RULE_DOOR, RULE_DOOR, RULE_WALL, RULE_DOOR],
		"weight": WEIGHT_INTERSECTION
	},
	"intersection_south": {
		"id": 9,
		"rules": [RULE_WALL, RULE_DOOR, RULE_DOOR, RULE_DOOR],
		"weight": WEIGHT_INTERSECTION
	},
	"intersection_east": {
		"id": 10,
		"rules": [RULE_DOOR, RULE_DOOR, RULE_DOOR, RULE_WALL],
		"weight": WEIGHT_INTERSECTION
	},
	"intersection_west": {
		"id": 11,
		"rules": [RULE_DOOR, RULE_WALL, RULE_DOOR, RULE_DOOR],
		"weight": WEIGHT_INTERSECTION
	},
	"corner_north_east": {
		"id": 12,
		"rules": [RULE_DOOR, RULE_DOOR, RULE_WALL, RULE_WALL],
		"weight": WEIGHT_CORNER
	},
	"corner_north_west": {
		"id": 13,
		"rules": [RULE_DOOR, RULE_WALL, RULE_WALL, RULE_DOOR],
		"weight": WEIGHT_CORNER
	},
	"corner_south_east": {
		"id": 14,
		"rules": [RULE_WALL, RULE_DOOR, RULE_DOOR, RULE_WALL],
		"weight": WEIGHT_CORNER
	},
	"corner_south_west": {
		"id": 15,
		"rules": [RULE_WALL, RULE_WALL, RULE_DOOR, RULE_DOOR],
		"weight": WEIGHT_CORNER
	}
}

class RoomWaveTile:
	var possibilities: Array
	var entropy: int
	var neighbours: Dictionary
	
	func _init(_possibilities: Array = ROOMS.keys()) -> void:
		setPossibilities(_possibilities)
	
	func setPossibilities(_possibilities: Array) -> void:
		possibilities = _possibilities.duplicate()
		entropy = possibilities.size()
	
	func getDirections() -> Array:
		return neighbours.keys()
	
	func collapse() -> void:
		var weights: Array[int] = []
		for p: String in possibilities:
			weights.append(ROOMS[p]["weight"])
		possibilities = [Utils.randomWeighted(possibilities, weights)]
		entropy = 0
	
	func constrain(neighbourPossibilities: Array, dir: Constants.Facing) -> bool:
		var reduced: bool = false
		if entropy > 0:
			var connectors: Array = []
			for p: String in neighbourPossibilities:
				connectors.append(ROOMS[p]["rules"][dir])
			
			var opposite: Constants.Facing
			if dir == Constants.Facing.UP:
				opposite = Constants.Facing.DOWN
			if dir == Constants.Facing.DOWN:
				opposite = Constants.Facing.UP
			if dir == Constants.Facing.RIGHT:
				opposite = Constants.Facing.LEFT
			if dir == Constants.Facing.LEFT:
				opposite = Constants.Facing.RIGHT
			
			for p: String in possibilities.duplicate():
				if !connectors.has(ROOMS[p]["rules"][opposite]):
					possibilities.erase(p)
					reduced = true
			entropy = possibilities.size()
		return reduced

@export var roomMap: TileMap
## How many rooms along the X/Y axis
@export var size: Vector2i = Vector2i(9, 5):
	set(value):
		size.x = clamp(value.x, 1, 50)
		size.y = clamp(value.y, 1, 50)
var spawnRoomPos: Vector2i

@export var stationSeed: String = ""

var rooms: Array[Array] = []

func _ready() -> void:
	size += Vector2i.ONE * 2 # Padding for empty tiles
	spawnRoomPos = size / 2
	
	if stationSeed.is_empty():
		stationSeed = str(randi())
	seed(stationSeed.hash())
	print("Station seed: ", stationSeed)
	
	call_deferred("generate")

func generate() -> void:
	var timeStart: int = Time.get_ticks_msec()
	init()
	#waveFunctionCollapse()
	var done: bool = false
	while !done:
		if !waveFunctionCollapse():
			done = true
	
	print("Placing rooms...")
	placeRooms()
	
	print("Removing unconnected rooms")
	removeSeperateRooms()
	print("Generation took %sms" % (Time.get_ticks_msec() - timeStart))
	
	%Player.global_position = roomMap.map_to_local(Vector2(spawnRoomPos))

func init() -> void:
	for y: int in size.y:
		var tiles: Array[RoomWaveTile] = []
		for x: int in size.x:
			var tile: RoomWaveTile = RoomWaveTile.new()
			if x == 0 || x == size.x - 1 || y == 0 || y == size.y - 1:
				tile.setPossibilities(["empty"])
			tiles.append(tile)
		rooms.append(tiles)
	
	rooms[spawnRoomPos.y][spawnRoomPos.x].setPossibilities(["intersection_north", "intersection_south", "intersection_east", "intersection_west"])
	
	for y: int in size.y:
		for x: int in size.x:
			var tile: RoomWaveTile = rooms[y][x]
			if y > 0:
				tile.neighbours[Constants.Facing.UP] = rooms[y - 1][x]
			if x < size.x - 1:
				tile.neighbours[Constants.Facing.RIGHT] = rooms[y][x + 1]
			if y < size.y - 1:
				tile.neighbours[Constants.Facing.DOWN] = rooms[y + 1][x]
			if x > 0:
				tile.neighbours[Constants.Facing.LEFT] = rooms[y][x - 1]

func waveFunctionCollapse() -> bool:
	var tilesLowestEntropy: Array[RoomWaveTile] = getTilesLowestEntropy()
	if tilesLowestEntropy.size() <= 0:
		return false
	
	var toCollapse: RoomWaveTile = tilesLowestEntropy.pick_random()
	toCollapse.collapse()
	
	var stack: Array[RoomWaveTile] = []
	stack.append(toCollapse)
	
	while !stack.is_empty():
		var tile: RoomWaveTile = stack.pop_back()
		var possibilities: Array = tile.possibilities
		var directions: Array = tile.getDirections()
		
		for dir: Constants.Facing in directions:
			var neighbour: RoomWaveTile = tile.neighbours[dir]
			if neighbour.entropy != 0 && neighbour.constrain(possibilities, dir):
				stack.append(neighbour)
	
	return true

func getTilesLowestEntropy() -> Array[RoomWaveTile]:
	var lowest: int = ROOMS.keys().size()
	var tiles: Array[RoomWaveTile] = []
	
	for y: int in size.y:
		for x: int in size.x:
			var entropy: int = rooms[y][x].entropy
			if entropy > 0:
				if entropy < lowest:
					tiles.clear()
					lowest = entropy
				if entropy == lowest:
					tiles.append(rooms[y][x])
	
	return tiles

func placeRooms() -> void:
	for y: int in size.y:
		for x: int in size.x:
			var tile: RoomWaveTile = rooms[y][x]
			@warning_ignore("untyped_declaration")
			var id = ROOMS[tile.possibilities[0]]["id"]
			if id is Array:
				var weights: Array = ROOMS[tile.possibilities[0]]["id-weights"]
				id = Utils.randomWeighted(id, weights)
			roomMap.set_cell(0, Vector2i(x, y), 3, Vector2i.ZERO, id)

func removeSeperateRooms() -> void:
	#var image: Image = Image.create(size.x, size.y, false, Image.FORMAT_L8)
	#image.fill(Color.BLACK)
	
	var roomsToCheck: Array[Vector2i] = [spawnRoomPos]
	var roomsChecked: Array[Vector2i] = []
	
	while !roomsToCheck.is_empty():
		var room: Vector2i = roomsToCheck.pop_front()
		if roomsChecked.has(room):
			continue
		
		var roomKey: String = rooms[room.y][room.x].possibilities[0]
		
		if ROOMS[roomKey]["rules"][0] == RULE_DOOR:
			roomsToCheck.append(Vector2i(room.x, room.y - 1))
		if ROOMS[roomKey]["rules"][1] == RULE_DOOR:
			roomsToCheck.append(Vector2i(room.x + 1, room.y))
		if ROOMS[roomKey]["rules"][2] == RULE_DOOR:
			roomsToCheck.append(Vector2i(room.x, room.y + 1))
		if ROOMS[roomKey]["rules"][3] == RULE_DOOR:
			roomsToCheck.append(Vector2i(room.x - 1, room.y))
		
		#image.set_pixelv(room, Color.WHITE)
		roomsChecked.append(room)
	
	#$"../CanvasLayer/TextureRect".texture = ImageTexture.create_from_image(image)
	
	var mapRooms: Array[Vector2i] = roomMap.get_used_cells(0).duplicate()
	for pos: Vector2i in mapRooms:
		if !roomsChecked.has(pos):
			roomMap.erase_cell(0, pos)
	print("Removed ", mapRooms.size() - roomsChecked.size(), " rooms")
	print("Room count: ", roomsChecked.size())
