extends Node2D

export var index = 0
export var child_nodes = []
export var nodes_needed = []
export var needed_nodes_unlocked = false
export var price = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton/Line2D.global_position = Vector2(0,0)
	updateNode()

func updateNode():
	if get_parent().nodes[index] == 1:
		modulate[3] = 1
	elif check_unlock():
		modulate[3] = 0.5
	else:
		modulate[3] = 0.2
	
	$TextureButton/Line2D.clear_points()
	if get_parent().nodes[index] == 1:
		for x in child_nodes:
			if get_parent().get_upgrade_node(x).check_unlock():
				var child = get_parent().get_upgrade_node(x).get_node("TextureButton")
				$TextureButton/Line2D.add_point($TextureButton.rect_position + Vector2(32,32))
				$TextureButton/Line2D.add_point(child.rect_position + Vector2(32,32))

func check_unlock():
	if nodes_needed.size() == 0:
		return true
	elif !needed_nodes_unlocked:
		for x in nodes_needed:
			if get_parent().nodes[get_parent().get_upgrade_node(x).index] == 1:
				return true
	elif needed_nodes_unlocked:
		for x in nodes_needed:
			if get_parent().nodes[get_parent().get_upgrade_node(x).index] == 0:
				return false
		return true


func _on_TextureButton_pressed():
	if check_unlock() and Data.overallTokens >= price:
		Data.buy_upgrade(price)
		get_parent().nodes[index] = 1
		get_parent().update_all_nodes()
