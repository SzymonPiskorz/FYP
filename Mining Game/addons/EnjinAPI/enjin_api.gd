extends Node

const APP_ID : int = 6132

var root_ready = false
var initialised = false

var bearer : String = ""
var user_id = -1
var user_identity
var logged_in : bool = false

var schema = null
var queued_queries = []
var SchemaScene = preload("res://addons/EnjinAPI/schema.tscn")

var app_secret : String = "taUtMbdJXMAaeUSJrcENV7PHGH3LTHidzHsqpFSm"
var app_token : String = ""
var eth_address : String = ""
var token_name: String = ""

func connect_to_enjin() -> void:
	if not root_ready:
		yield(get_tree().root, "ready")
		
	GraphQL.set_endpoint(true, "kovan.cloud.enjin.io/graphql", 0, "")
	_setup()

func login(username : String, password : String):
	_execute("login_query", {
		"email": username, "password":password })

func logout():
	schema.remove_bearer()
	bearer = ""
	user_id = -1

func get_app_access_token():
	_execute("get_app_access_token", {
		"id" : APP_ID,
		"secret": app_secret,
	})

func get_user(id : int):
	_execute("get_user",{
		"id": id
	})

func get_token_amount():
	_execute("get_token_amount", {
		"tokenId": "1000000000003af3", 
		"ethAddress": eth_address,
	})

func view_token():
	_execute("view_token",{"name":"Mini Slav Coin",})

func mint(amount : int):
	_execute("mint", {
		"identityId": 23916, "appId": 6132,
		"tokenId": "1000000000003af3", "recipientAddress": eth_address,
		"value": amount,
	})

func send(amount : int):
	_execute("send", {
		"identityId": user_identity, "appId": APP_ID,
		"tokenId": "1000000000003af3", "recipientAddress": "0xefFa6E677804CE68A0a00C2bAad08360Eb7aa665",
		"value": amount,
	})

func create_identity(user_id : int, eth_address : String):
	_execute("create_identity", {
		"appId": APP_ID,
		"userId": user_id,
		"ethAddress": eth_address,
	})

func set_ethAddress(eth_Address : String):
	eth_address = eth_Address

func _setup():
	var root = get_tree().root
	schema = SchemaScene.instance()
	root.add_child(schema)
	
	# Connects the queries and mutations' signals to methods.
	schema.login_query.connect("graphql_response", self, "_login_response")
	schema.get_user.connect("graphql_response", self, "get_user_response")
	schema.create_identity.connect("graphql_response", self, "create_identity_response")
	schema.get_token_amount.connect("graphql_response", self, "get_token_amount_response")
	
	
	#schema.get_app_secret_query.connect("graphql_response", self, "_get_app_secret_response")
	schema.get_app_access_token.connect("graphql_response", self, "_get_app_access_token_response")
	
	initialised = true
	
	# Runs any queued queries.
	if queued_queries.size():
		for query in queued_queries:
			schema.get(query.query_name).run(query.args)

func _execute(query_name : String, args : Dictionary):
	if initialised:
		schema.get(query_name).run(args)
		
	else:
		queued_queries.append({
			query_name = query_name,
			args = args,
		})

func _on_tree_ready():
	root_ready = true

func _login_response(result):
	print(JSON.print(result, "\t"))
	
	var auth = result.data.EnjinOauth
	
	if auth != null:
		user_id = auth.id
		get_app_access_token()
		
		

func get_user_response(result):
	print(JSON.print(result, "\t"))
	
	var auth = result.data.EnjinUser.identities
	
	if auth.size() > 0:
		set_ethAddress(auth[0].wallet.ethAddress)
		for identity in auth:
			if identity.app.id == APP_ID:
				user_identity = identity.id
				get_token_amount()
				logged_in = true

func get_token_amount_response(result):
	print(JSON.print(result, "\t"))
	
	var auth = result.data.EnjinBalances
	
	if auth.size() > 0:
		for balance in auth:
			if balance.token.id == "1000000000003af3":
				Data.overallTokens = balance.value

func create_identity_response(result):
	print(JSON.print(result, "\t"))

func _get_app_secret_response(result):
	var secret = result.data.EnjinApps[0].secret
	if secret != null:
		schema.retrieve_app_access_token_query.set_bearer(bearer)
		schema.retrieve_app_access_token_query.run({
			"appId": APP_ID,
			"appSecret": secret,
		})
		
		schema.create_player_mutation.set_bearer(bearer)
		schema.create_player_mutation.run({ "playerId": "Szymon" })

func _get_app_access_token_response(result):
	print(JSON.print(result, "\t"))
	
	var auth = result.data.AuthApp
	
	if auth != null:
		app_token = auth.accessToken
		bearer = app_token
		schema.set_bearer(bearer)
		get_user(EnjinApi.user_id)

func _create_player_response(result):
	print(JSON.print(result, "\t"))
