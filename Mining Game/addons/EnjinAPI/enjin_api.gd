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

var app_token : String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI2MTMyIiwianRpIjoiZDAwNzc3MGU5MGQ5OWY4OTBlNTk4Njc1NDZiOTIxMjNlOGY4NTMzMWFiZGViYmVkMDI2NmQ3Y2E3MWI1MThkZDQ3NmUzNWIwYjAyYWQ2NzUiLCJpYXQiOjE2NTA5Njg2OTQuNTYxOTI5LCJuYmYiOjE2NTA5Njg2OTQuNTYxOTMxLCJleHAiOjE2NTEwNTUwOTQuNTUzNDUsInN1YiI6IiIsInNjb3BlcyI6WyJhcGkiXX0.OSp6Tn33uMt3LkelW1PHJNJt6vu8U7ApS1NEU7fK4N6La4MJNvyd_uwD_cSe4aTClPTDqL7kvZkz3y8qNwuFK82Pwj8ibAHRCnMLLlM8i3rjOX-SEWgdHkP_DZHN6iwVa-7TcQiC-EhgtLJhHd2j8fKOfjHIdHzNhjB9SzCkKGxtg6TJbUQ6mAoxSWkKDiRopDrZiX4xtz6FNuRRbvo_93g4gjCx7X16KlPo7azoguRVIIOIbff2vjxiazDaVISBIUeSYQQMH6vVFqP1UbutNY3mRsnlo-avmXQlckoJSXLixek-roJt54gvTYJSoQQQI1p42jpAi3XHmlOyGWrwRZAa-sxLgxNufW9UVbvZvMA6PABrsXyMJeDMdvdC83_T_IQc7pM8dyrTobl8koHE5q6oXZjTu36XfZFC2gMULd3S6c_DxAKC0Q-LTRG_5BBSoWhOrOQPrf2uTEaDcGDWfaXUJTAvu5eRYYLJyAwx_xpgc5qPNi3mA48jTsZTOfzF308EYaTfNPBbu6GuFLbXIpWULLYF0KaYZE9tCpozIEAKKPGS5vTVUt7NsBD_D0-rY-QeZ-7sAHBaGN2ikDPqkaSEg7kXAFEzJTpPR_4OHLop8QV38InseifaF5i3vS4yVf5TBqsFbgUtRPfJzoCWJ8E7kJj0F1v8BMN2XW3jBPM"
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
	#schema.retrieve_app_access_token_query.connect("graphql_response", self, "_retrieve_app_access_token_response")
	
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
		bearer = app_token#auth.accessTokens[0].accessToken
		schema.set_bearer(bearer)
		get_user(EnjinApi.user_id)

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

func _retrieve_app_access_token_response(result):
	print(JSON.print(result, "\t"))

func _create_player_response(result):
	print(JSON.print(result, "\t"))
