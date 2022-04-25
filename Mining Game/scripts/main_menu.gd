extends Node

func _ready():
	EnjinApi.connect_to_enjin()



func _on_Play_pressed():
	get_tree().change_scene("res://scenes/login.tscn")


func _on_Settings_pressed():
	get_tree().change_scene("res://scenes/settingScreen.tscn")


func _on_Help_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
