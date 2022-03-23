extends StaticBody2D

export var health = 10
export var tokens_given = 1

func _damage(t_damage):
	health -= t_damage
	if health <= 0:
		return true

func _giveTokens():
	return tokens_given
