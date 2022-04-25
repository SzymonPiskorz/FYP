extends Control

onready var _volume_progress = find_node("ProgressBar")

func _on_HSlider_value_changed(value):
	_volume_progress.value = value
	
	var _max_volume = 20
	var _db_sound = 0
	
	if value == 50:
		_db_sound = 0
	elif value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	elif  value < 50:
		var difference = 50 - value
		_db_sound -= difference
		
	elif value > 50:
		var difference = value - 50
		_db_sound += difference * 0.05
	#elif value >= 99:
		#_db_sound = 0
	
	if value > 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _db_sound)


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
