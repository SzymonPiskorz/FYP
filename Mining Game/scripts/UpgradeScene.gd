extends Control

onready var OverallTokens = $Panel/TokenAmount

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/MainScene.tscn")

func _process(_delta):
	OverallTokens.text = "Overall Tokens: " + Data.overallTokens as String
