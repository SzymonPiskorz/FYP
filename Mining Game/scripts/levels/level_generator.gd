extends Node
signal level_generated(level_tiles)
tool

# ------------------------------------------------------------------------------
# SIMPLEX NOISE PROPERTY DESCRIPTIONS
# ------------------------------------------------------------------------------
# === OCTAVES ===
# Number of OpenSimplex noise layers that are sampled to get the fractal noise. 
# Higher values result in more detailed noise but take more time to generate.
# Have a min vlaue of 1 and max of 9.
#
# === PERIOD ===
# Period of the base octave. A lower period results in higher-frequency noise
# 	(more value changes accross the same distance).
#
# === LACUNARITY ===
# Difference in period between octaves.
#
# === PERSISTENCE ===
# The contribution factor of the different octaves. A persistence value of 1 
# 	means all octaves have the same contribution, a value of 0.5 means each
# 	octave contributes half as much as the previous one.

var params = {
	"octaves": 2,
	"period": 64,
	"lacunarity": 2.0,
	"persistence": 0.75,
	"randomize_seed": true,
}

const WIDTH = 400
const HEIGHT = 400

func _get_property_list():
	return [
		{ name = "octaves", hint = PROPERTY_HINT_RANGE, hint_string = "1,9,1", type = TYPE_REAL },
		{ name = "period", hint = PROPERTY_HINT_RANGE, hint_string = "-500,500", type = TYPE_REAL },
		{ name = "lacunarity", hint = PROPERTY_HINT_RANGE, hint_string = "-5,5", type = TYPE_REAL },
		{ name = "persistence", hint = PROPERTY_HINT_RANGE, hint_string = "-5,5", type = TYPE_REAL },
		{ name = "randomize_seed", type = TYPE_BOOL },
		{ name = "generate", type = TYPE_BOOL },
	]
		

# ------------------------------------------------------------------------------
func _set(property, value):
	if params.has(property):
		params[property] = value
		
	if Engine.editor_hint:
		generate_level()


# ------------------------------------------------------------------------------
func _get(property):
	if params.has(property):
		return params[property]


# ------------------------------------------------------------------------------
func generate_level():

	var simplex_map = OpenSimplexNoise.new()
	
	# If running in the editor, uses the generation's own properties.
	if Engine.editor_hint:
		# Sets the height map noise properties.
		if params["randomize_seed"]:
			simplex_map.seed = randi()
			
		simplex_map.octaves = params["octaves"]
		simplex_map.period = params["period"]
		simplex_map.lacunarity = params["lacunarity"]
		simplex_map.persistence = params["persistence"]
	
	# If running in the game, uses level data's properties.
	else:
		# Sets the height map noise properties.
		simplex_map.seed = LevelData.noise_seed
		simplex_map.octaves = LevelData.height_octaves
		simplex_map.period = LevelData.height_period
		simplex_map.lacunarity = LevelData.height_lacunarity
		simplex_map.persistence = LevelData.height_persistence
		
	var tiles = []
	
	for x in WIDTH:
		tiles.append([])
		
		for y in HEIGHT:
			tiles[x].append(0)
			
			var noise_sample = simplex_map.get_noise_2d(float(x), float(y))
			tiles[x][y] = _get_tile(noise_sample)
			
	
	emit_signal("level_generated", tiles)


# ------------------------------------------------------------------------------
func _get_tile(noise_sample):
	if noise_sample < 0:
		return 44
	
	return -1
