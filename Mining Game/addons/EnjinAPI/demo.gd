extends Node

func _ready():
	EnjinApi.connect_to_enjin()
	EnjinApi.login(Secret.username, Secret.password)
	#EnjinApi.set_ethAddress("0x8e6b2a4c5bc30ae3c801a9a0e7a125f1282d99f6")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		EnjinApi.logout()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_new_identity()
	
	if Input.is_action_just_pressed("ui_left"):
		EnjinApi.get_user(EnjinApi.user_id)
	
	if Input.is_action_just_pressed("ui_right"):
		EnjinApi.send()


func get_new_identity():
	EnjinApi.create_identity(EnjinApi.user_id, EnjinApi.eth_address)
