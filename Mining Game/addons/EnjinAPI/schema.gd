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

onready var mint = GraphQL.mutation("mintFungibleItems", {
		"identityId": "Int!",
		"appId": "Int!",
		"type": "TransactionType!",
		"token_id": "String!",
		"amount": "Int!",
		"address": "String!",
	}, GQLQuery.new("CreateEnjinRequest").set_args({
		"identityId": "identityId",
		"appId": "appId",
		"type": "type",
	}).set_props([
		GQLQuery.new("mint_token_data").set_args({
			"token_id": "token_id",
			"recipient_address_array": "address",
			"value_array": "amount",
		})
	]))

onready var send = GraphQL.mutation("SendToken", {
		"identityId": "Int!",
		"appId": "Int!",
		"type": "TransactionType!",
	}, GQLQuery.new("CreateEnjinRequest").set_args({
		"identityId": "identityId",
		"appId": "appId",
		"type": "type",
	}).set_props([
		GQLQuery.new("send_token_data").set_args({
			"token_id": "1000000000003af3",
			"recipient_address_array": "0xefFa6E677804CE68A0a00C2bAad08360Eb7aa665",
			"value_array": "1",
		})
	]))

func set_bearer(bearer : String):
	login_query.set_bearer(bearer)
	get_app_secret_query.set_bearer(bearer)
	retrieve_app_access_token_query.set_bearer(bearer)
	get_user.set_bearer(bearer)
	create_identity.set_bearer(bearer)
	mint.set_bearer(bearer)
	send.set_bearer(bearer)

func remove_bearer():
	login_query.remove_bearer()
	get_app_secret_query.remove_bearer()
	retrieve_app_access_token_query.remove_bearer()
	get_user.remove_bearer()
	create_identity.remove_bearer()
	mint.remove_bearer()
	send.remove_bearer()

func _ready():
	add_child(login_query)
	add_child(get_app_secret_query)
	add_child(retrieve_app_access_token_query)
	add_child(get_user)
	add_child(create_identity)
	add_child(mint)
	add_child(send)
