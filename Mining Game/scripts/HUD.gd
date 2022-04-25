extends Node

onready var HealthBar = $Header/Health/HealthBar
onready var TokensCollected = $Header/TokensCollected
onready var OverallTokens = $Header/OverallTokens
onready var ItemSlot1_tex = $Footer/ItemSlot1/ItemTexture
onready var ItemSlot1_label = $Footer/ItemSlot1/Label
onready var ItemSlot2_tex = $Footer/ItemSlot2/ItemTexture
onready var ItemSlot2_label = $Footer/ItemSlot2/Label
onready var ItemSlot3_tex = $Footer/ItemSlot3/ItemTexture
onready var ItemSlot3_label = $Footer/ItemSlot3/Label
onready var ItemSlot3_amount = $Footer/ItemSlot3/NumAmount
onready var ItemSlot4_tex = $Footer/ItemSlot4/ItemTexture
onready var ItemSlot4_label = $Footer/ItemSlot4/Label
onready var ItemSlot4_amount = $Footer/ItemSlot4/NumAmount
onready var ItemSlot5_tex = $Footer/ItemSlot5/ItemTexture
onready var ItemSlot5_label = $Footer/ItemSlot5/Label
onready var ItemSlot5_amount = $Footer/ItemSlot5/NumAmount

var time : float
var TIME_PERIOD : float  = 15

func _ready():
	ItemSlot1_label.text = 1 as String
	ItemSlot1_tex.texture = load("res://assets/weaponsAndUtilities/eternalGaze.png")
	
	ItemSlot2_label.text = 2 as String
	ItemSlot2_tex.texture = load("res://assets/weaponsAndUtilities/Pick1.png")
	
	ItemSlot3_label.text = 3 as String
	ItemSlot3_tex.texture = load("res://assets/weaponsAndUtilities/teleportMedallionIcon.png")
	
	ItemSlot4_label.text = 4 as String
	ItemSlot4_tex.texture = load("res://assets/consumables/smallHpBottle1.png")
	
	ItemSlot5_label.text = 5 as String
	ItemSlot5_tex.texture = load("res://assets/consumables/HpBottle1.png")

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
	ItemSlot4_amount.text = Data.small_hp_bottle_amount as String
	ItemSlot5_amount.text = Data.hp_bottle_amount as String
