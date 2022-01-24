extends Area2D


func _on_Pickaxe_body_entered(body):
	if body.is_in_group("Token"):
		if body._damage(1):
			get_parent()._addTokens(body._giveTokens())
			body.queue_free()
