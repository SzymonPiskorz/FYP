extends Control

onready var gameInfoButton : Button = $Panel/GameInfoButton
onready var loginInfoButton : Button = $Panel/LoginScreenButton
onready var hudInfoButton : Button = $Panel/HudInfoButton
onready var gameInfoTexture : TextureRect = $Panel/GameInfo 
onready var loginInfoTexture : TextureRect = $Panel/LoginInfo
onready var hudInfoTexture : TextureRect = $Panel/HudInfo

func _ready():
	gameInfoButton.disabled = true
	gameInfoTexture.show()
	
	loginInfoButton.disabled = false
	hudInfoButton.disabled = false
	loginInfoTexture.hide()
	hudInfoTexture.hide()

func _on_GameInfoButton_pressed():
	gameInfoButton.disabled = true
	loginInfoButton.disabled = false
	hudInfoButton.disabled = false
	
	gameInfoTexture.show()
	loginInfoTexture.hide()
	hudInfoTexture.hide()


func _on_LoginScreenButton_pressed():
	gameInfoButton.disabled = false
	loginInfoButton.disabled = true
	hudInfoButton.disabled = false
	
	gameInfoTexture.hide()
	loginInfoTexture.show()
	hudInfoTexture.hide()


func _on_HudInfoButton_pressed():
	gameInfoButton.disabled = false
	loginInfoButton.disabled = false
	hudInfoButton.disabled = true
	
	gameInfoTexture.hide()
	loginInfoTexture.hide()
	hudInfoTexture.show()


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
