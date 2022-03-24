extends TextureRect

var nodes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	nodes = Data.upgrades
	update_all_nodes()
	

func get_upgrade_node(index):
	for x in get_children():
		if x.index == index:
			return x

func update_all_nodes():
	for x in get_children():
		x.updateNode()
