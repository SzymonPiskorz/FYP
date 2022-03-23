extends Node

var overallTokens : int = 0
var current_tokens : int = 0
var player_health : int = 0
var player_max_speed : int = 100
var player_acceleration : int = 200
var player_jump_speed : int = 300
var sword_dmg : int = 2
var pickaxe_dmg : int = 1

func add_to_overall_tokens():
	overallTokens += current_tokens
	current_tokens = 0

func buy_upgrade(price):
	overallTokens -= price
