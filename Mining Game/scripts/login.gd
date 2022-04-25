extends Control

var user : String = ""
var password : String = ""
var eth_adress : String = ""

var usert : String = "szymonpiskorz1999116@gmail.com"
var passwordt : String = "Szy61199mon"
var eth_adresst : String = "0xefFa6E677804CE68A0a00C2bAad08360Eb7aa665"

func _ready():
	#EnjinApi.connect_to_enjin()
	pass


func _on_Button_pressed():
	if user != "" and password != "" and eth_adress !="":
		EnjinApi.set_ethAddress(eth_adress)
		EnjinApi.login(user, password)

func _process(_delta):
	if EnjinApi.logged_in:
		get_tree().change_scene("res://scenes/MainScene.tscn")

func _on_Username_text_entered(new_text):
	user = new_text
	print(new_text)


func _on_Password_text_entered(new_text):
	password = new_text
	print(new_text)


func _on_Wallet_text_entered(new_text):
	eth_adress = new_text
	print(new_text)
