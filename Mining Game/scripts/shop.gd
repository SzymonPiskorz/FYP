extends Control

onready var OverallTokens = $Panel/TokenAmount

func _on_Back_Button_pressed():
	get_tree().change_scene("res://scenes/MainScene.tscn")


func _on_Item1Button_pressed():
	if Data.overallTokens >= 4:
		Data.buy_item(4, 1)


func _on_Item2Button_pressed():
	if Data.overallTokens >= 8:
		Data.buy_item(8, 2)

func _process(_delta):
	OverallTokens.text = "Overall Tokens: " + Data.overallTokens as String
