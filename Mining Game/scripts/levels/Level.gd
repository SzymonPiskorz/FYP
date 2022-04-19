extends Node
tool

var tile_size : Vector2  = Vector2.ZERO
onready var tile_map : TileMap = $TileMap
var offset : Vector2 = Vector2(8, 8)

func _ready() -> void:
	if not Engine.editor_hint:
		
		$LevelGenerator.generate_level()

func _on_LevelGenerator_level_generated(level_tiles):
	tile_size = offset * 2.0 # TEMP
	for x in range(level_tiles.size()):
		for y in range(level_tiles[x].size()):
			$TileMap.set_cell(x, y, level_tiles[x][y])
