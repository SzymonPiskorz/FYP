extends StaticBody2D

export var health = 3
export var tokens_given = 10

func _damage(t_damage):
	health -= t_damage
	if health <= 0:
		return true

func _giveTokens():
	return tokens_given
