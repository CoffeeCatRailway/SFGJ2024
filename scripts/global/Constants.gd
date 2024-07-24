extends Node

## Facing enum
enum Facing {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

## Tilemaps & Layers
enum Layers {
	WALLS = 0,
	FLOOR = 1
}

enum Terrains {
	FLOOR = 0
}

#const cropsAtlasId: int = 5
#const soilAtlasId: int = 9
#
#const cropCornAtlasCoords: Vector2i = Vector2i(0, 0)
#const cropCornGrowthStages: int = 5
#
#const soilHoedAtlasCoords: Vector2i = Vector2i(5, 6)
