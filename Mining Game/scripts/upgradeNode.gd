extends Node2D

export var index = 0
export var child_nodes = []
export var nodes_needed = []
export var needed_nodes_unlocked = false
export var price = 0
export var upgrade_info : String



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
	if check_unlock() and Data.overallTokens >= price and get_parent().nodes[index] != 1:
		Data.buy_upgrade(price)
		get_parent().nodes[index] = 1
		Data.upgrades[index] = 1
		change_stat(index)
		get_parent().update_all_nodes()


func _on_TextureButton_mouse_entered():
	var popup : PopupDialog = find_node("UpgradeInfo")
	popup.get_child(0).text = "Price: " + price as String + "\n" + upgrade_info
	popup.popup()


func _on_TextureButton_mouse_exited():
	var popup : PopupDialog = find_node("UpgradeInfo")
	popup.get_child(0).text = "Price: " + price as String + "\n" + upgrade_info
	popup.hide()

func change_stat(index : int) -> void:
	if index == 1:
		speed_increase()
		jump_increase()
	elif index >= 4 and index <= 7:
		speed_increase()
	elif index >= 8 and index <= 11:
		jump_increase()
	elif index == 2:
		attack_increase()
		def_increase()
	elif index >= 12 and index <= 15:
		attack_increase()
	elif index >= 16 and index <= 19:
		def_increase()
	elif index == 3:
		mining_DMG_increase()
	elif index >= 20 and index <= 23:
		mining_DMG_increase()

func speed_increase():
	Data.player_max_speed += 50
	Data.player_acceleration += 25

func jump_increase():
	Data.player_jump_speed += 25

func attack_increase():
	Data.sword_dmg += 2

func def_increase():
	Data.player_armour += 10

func mining_DMG_increase():
	Data.pickaxe_dmg += 2
