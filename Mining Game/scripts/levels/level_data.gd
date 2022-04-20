extends Node
const WIDTH = 400
const HEIGHT = 400
var noise_seed = 0

var octaves = 3
var period = 80
var lacunarity = 2
var persistence = 1.5

var use_data = false

func _ready():
	randomize()
	noise_seed = randi()
 
