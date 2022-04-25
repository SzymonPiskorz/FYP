extends Node

onready var HealthBar = $Header/Health/HealthBar
onready var TokensCollected = $Header/TokensCollected
onready var OverallTokens = $Header/OverallTokens
onready var ItemSlot1_tex = $Footer/ItemSlot1/ItemTexture
onready var ItemSlot1_label = $Footer/ItemSlot1/Label
onready var ItemSlot2_tex = $Footer/ItemSlot2/ItemTexture
onready var ItemSlot2_label = $Footer/ItemSlot2/Label

var time : float
var TIME_PERIOD : float  = 20

func _ready():
	ItemSlot1_label.text = 1 as String
	ItemSlot1_tex.texture = load("res://assets/weaponsAndUtilities/eternalGaze.png")
	
	ItemSlot2_label.text = 2 as String
	ItemSlot2_tex.texture = load("res://assets/weaponsAndUtilities/Pick1.png")

func _on_Player_health_changed(value : int) -> void:
	HealthBar.value = value

func _on_Player_tokens_changed(value) -> void:
	TokensCollected.text = "Tokens Collected: " + value as String

func _process(_delta):
	time += _delta
	
	if time > TIME_PERIOD:
		time = 0
		EnjinApi.get_token_amount()
	
	OverallTokens.text = "Overall Tokens: " + Data.overallTokens as String
