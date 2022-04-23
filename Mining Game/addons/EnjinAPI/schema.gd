extends Node

onready var login_query = GraphQL.query("Login", {
		"email": "String!",
		"password": "String!",
	}, GQLQuery.new("EnjinOauth").set_args({ 
		"email": "email",
		"password": "password",
	}).set_props([
		"id",
		"name",
		"accessTokens",
	]))

onready var get_user = GraphQL.query("GetUser", { "id": "Int!"},
	GQLQuery.new("EnjinUser").set_args({
		"id":"id",
	}).set_props([
		"name",
		GQLQuery.new("identities").set_props([
			GQLQuery.new("app").set_props([
				"id",
				"name",
			]),
			GQLQuery.new("wallet").set_props([
				"ethAddress",
			])
		]),
		GQLQuery.new("items").set_props([
				"id",
				"name",
			]),
	]))

onready var get_app_secret_query = GraphQL.query("GetAppSecret", {
		"id": "Int!",
	}, GQLQuery.new("EnjinApps").set_args({ 
		"id": "id",
	}).set_props([
		"secret",
	]))
	

onready var retrieve_app_access_token_query = GraphQL.query("RetrieveAppAccessToken", {
		"appId": "Int!",
		"appSecret": "String!",
	}, GQLQuery.new("AuthApp").set_args({ 
		"appId": "id",
		"appSecret": "secret",
	}).set_props([
		"accessToken",
		"expiresIn",
	]))

onready var create_identity = GraphQL.mutation("CreateIdentity", {
		"userId": "Int!",
		"appId": "Int!",
		"ethAddress": "String!",
	}, GQLQuery.new("CreateEnjinIdentity").set_args({ 
		"userId": "userId",
		"appId": "appId",
		"ethAddress": "ethAddress",
	}).set_props([
		"id",
		"createdAt",
		GQLQuery.new("wallet").set_props([
			"ethAddress",
		]),
	]))

func set_bearer(bearer : String):
	login_query.set_bearer(bearer)
	get_app_secret_query.set_bearer(bearer)
	retrieve_app_access_token_query.set_bearer(bearer)
	get_user.set_bearer(bearer)
	create_identity.set_bearer(bearer)

func remove_bearer():
	login_query.remove_bearer()
	get_app_secret_query.remove_bearer()
	retrieve_app_access_token_query.remove_bearer()
	get_user.remove_bearer()
	create_identity.remove_bearer()

func _ready():
	add_child(login_query)
	add_child(get_app_secret_query)
	add_child(retrieve_app_access_token_query)
	add_child(get_user)
	add_child(create_identity)
