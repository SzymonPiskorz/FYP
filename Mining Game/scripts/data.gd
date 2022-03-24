extends Node

var overallTokens : int = 103 #tokens to test all upgrades
var current_tokens : int = 0
var player_health : int = 0
var player_max_speed : int = 100
var player_acceleration : int = 200
var player_jump_speed : int = 300
var sword_dmg : int = 2
var pickaxe_dmg : int = 1
var player_armour : int = 0

var upgrades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func add_to_overall_tokens():
	overallTokens += current_tokens
	current_tokens = 0

func buy_upgrade(price):
	overallTokens -= price
