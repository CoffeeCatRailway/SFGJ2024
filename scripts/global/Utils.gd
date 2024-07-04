extends Node

func tweenBounce(node: Node, x: float = .8, y: float = 1.4) -> void:
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2(x, y), .04)
	tween.tween_property(node, "scale", Vector2.ONE, .04)
	await tween.finished
	tween.kill()

func isMoveKeyPressed() -> bool:
	return Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")

## Tilemap
func getCustomData(tilemap: TileMap, tilePos: Vector2i, layerName: String, layer: Constants.Layers) -> Variant:
	var tileData: TileData = tilemap.get_cell_tile_data(layer, tilePos)
	if tileData:
		return tileData.get_custom_data(layerName)
	return false

func setCustomData(tilemap: TileMap, tilePos: Vector2i, layerName: String, layer: Constants.Layers, value: Variant) -> bool:
	var tileData: TileData = tilemap.get_cell_tile_data(layer, tilePos)
	if tileData:
		tileData.set_custom_data(layerName, value)
		return true
	return false
#
func isTileEmpty(tilemap: TileMap, pos: Vector2i, layers: Array = [Constants.Layers.WALLS]) -> bool:
	for layer: Constants.Layers in layers:
		if tilemap.get_used_cells(layer).has(pos):
			return false
	return true
