extends Node
tool

var tile_size : Vector2  = Vector2.ZERO
onready var tile_map : TileMap = $TileMap
var offset : Vector2 = Vector2(8, 8)

onready var b_enemy = preload("res://scenes/BasicEnemy.tscn")
onready var n_enemy = preload("res://scenes/NormalEnemy.tscn")
onready var mb_enemy = preload("res://scenes/MiniBossEnemy.tscn")
onready var token_block = preload("res://scenes/Token.tscn")

var on_ground_dict : Dictionary

func _ready() -> void:
	if not Engine.editor_hint:
		
		$LevelGenerator.generate_level()
	
	_spawnEnemies()
	_spawnTokenBlocks()

func _on_LevelGenerator_level_generated(level_tiles):
	tile_size = offset * 2.0
	var pos : Vector2
	for x in range(level_tiles.size()):
		for y in range(level_tiles[x].size()):
			$TileMap.set_cell(x, y, level_tiles[x][y])
			pos.x = x
			pos.y = y
			if level_tiles[x][y] == 44:
				if level_tiles[x][y-1] == -1:
					var pos2 = Vector2(x, y-1)
					if !on_ground_dict.has(pos2):
						on_ground_dict[pos2] = {
							free = true,
							}

func _spawnEnemies():
	var data = Data
	var b_enemies = 8 + (data.b_enemy_per_d * data.difficulty)
	var n_enemies = 7 + (data.n_enemy_per_d * data.difficulty)
	var mb_enemies = 1 + (data.mb_enemy_per_d * data.difficulty)
	
	var pos
	var i = 0
	while i < b_enemies:
		pos = Vector2(rand_range(0, 400) as int, rand_range(0, 400) as int)
		if on_ground_dict.has(pos):
			var enemy = b_enemy.instance()
			add_child(enemy)
			enemy.position = $TileMap.map_to_world(pos) + (tile_size *0.5)
			i += 1
	
	i = 0
	while i < n_enemies:
		pos = Vector2(rand_range(0, 400) as int, rand_range(0, 400) as int)
		if on_ground_dict.has(pos):
			var enemy = n_enemy.instance()
			add_child(enemy)
			enemy.position = $TileMap.map_to_world(pos) + (tile_size *0.5)
			i += 1
	
	i = 0
	while i < mb_enemies:
		pos = Vector2(rand_range(0, 400) as int, rand_range(0, 400) as int)
		if on_ground_dict.has(pos):
			var enemy = mb_enemy.instance()
			add_child(enemy)
			enemy.position = $TileMap.map_to_world(pos) + tile_size
			i += 1

func _spawnTokenBlocks():
	var data = Data
	var token_blocks = 10 + (data.tokens_per_d * data.difficulty)
	
	var pos
	var i = 0
	while i < token_blocks:
		pos = Vector2(rand_range(0, 400) as int, rand_range(0, 400) as int)
		if on_ground_dict.has(pos):
			var token = token_block.instance()
			add_child(token)
			token.position = $TileMap.map_to_world(pos) + tile_size *0.5
			i += 1
