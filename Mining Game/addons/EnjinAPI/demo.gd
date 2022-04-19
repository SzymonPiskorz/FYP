extends Node

func _ready():
	EnjinApi.connect_to_enjin()
	EnjinApi.login(Secret.username, Secret.password)
