extends Node

var overallTokens : int #= 103 #tokens to test all upgrades
var current_tokens : int = 0
var player_health : int = 0
var player_max_speed : int = 100
var player_acceleration : int = 200
var player_jump_speed : int = 300
var sword_dmg : int = 2
var pickaxe_dmg : int = 1
var player_armour : int = 0

var difficulty = -1
var b_enemy_per_d = 3
var n_enemy_per_d = 2
var mb_enemy_per_d = 1
var tokens_per_d = 2

var upgrades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func add_to_overall_tokens():
	overallTokens += current_tokens
	if current_tokens != 0:
		EnjinApi.mint(current_tokens)
	current_tokens = 0

func buy_upgrade(price):
	overallTokens -= price
	if price != 0:
		EnjinApi.send(price)

func reset_difficulty():
	difficulty = -1
	print(difficulty)

func up_difficulty():
	difficulty += 1
	print(difficulty)
