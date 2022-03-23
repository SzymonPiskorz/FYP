extends Area2D

onready var pickaxe_damage = Data.pickaxe_dmg

func _on_Pickaxe_body_entered(body):
	if body.is_in_group("Token"):
		if body._damage(pickaxe_damage):
			get_parent()._addTokens(body._giveTokens())
			body.queue_free()
