extends Area2D

onready var sword_damage = Data.sword_dmg

func _on_Sword_body_entered(body):
	if body.is_in_group("Enemy"):
		body._damageE(sword_damage)
