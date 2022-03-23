extends Node

var overallTokens : int = 0
var current_tokens : int = 0

func add_to_overall_tokens():
	overallTokens += current_tokens
	current_tokens = 0

func buy_upgrade(price):
	overallTokens -= price
