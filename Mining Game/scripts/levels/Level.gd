extends Node
tool

var tile_size : Vector2  = Vector2.ZERO
onready var tile_map : TileMap = $TileMap
var offset : Vector2 = Vector2(8, 8)

func _ready() -> void:
	if not Engine.editor_hint:
		
		$LevelGenerator.generate_level()
	
	_spawnEnemies()
	_spawnTokenBlocks()

func _on_LevelGenerator_level_generated(level_tiles):
	tile_size = offset * 2.0 # TEMP
	for x in range(level_tiles.size()):
		for y in range(level_tiles[x].size()):
			$TileMap.set_cell(x, y, level_tiles[x][y])

func _spawnEnemies():
	var data = Data
	var b_enemies = 8 + (data.b_enemy_per_d * data.difficulty)
	var n_enemies = 7 + (data.n_enemy_per_d * data.difficulty)
	var mb_enemies = 1 + (data.mb_enemy_per_d * data.difficulty)
	
	for i in b_enemies:
		pass

func _spawnTokenBlocks():
	var data = Data
	var token_blocks = 10 + (data.tokens_per_d * data.difficulty)
	
	for i in token_blocks:
		pass
