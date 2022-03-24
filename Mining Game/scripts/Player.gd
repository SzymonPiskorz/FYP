extends KinematicBody2D

signal health_changed(value)
signal tokens_changed(value)

export var max_speed = 300.0
export var acceleration = 500.0
export var friction = 0.97
export var gravity = 9.8
export var jump_speed = 400.0
var velocity = Vector2.ZERO

var player_health = 0
var player_max_health : int = 100
export var player_died = false
export var player_damage = 1
var currently_equiped = 2
var current_tokens = 0
var player_armour : int = 0

var oVec = Vector2(0, -3)
var oRD = -45

func _ready():
	_equip(currently_equiped)
	_addTokens(Data.current_tokens)
	
	if Data.player_health != 0:
		change_health(Data.player_health)
	else:
		change_health(player_max_health)
	
	max_speed = Data.player_max_speed
	acceleration = Data.player_acceleration
	jump_speed = Data.player_jump_speed
	player_armour = Data.player_armour

func _physics_process(delta):
	velocity.y += gravity
	
	var input = 0.0
	
	if Input.is_action_pressed("Right"):
		input += 1.0
	
	if Input.is_action_pressed("Left"):
		input -= 1.0
	
	if Input.is_action_pressed("1"):
		_equip(2)
	if Input.is_action_pressed("2"):
		_equip(3)
	
	if Input.is_action_pressed("attack"):
		_attack(currently_equiped)
	
	velocity.x += input * acceleration * delta
	
	if input == 0.0:
		velocity.x  = velocity.x * friction
	
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)
	
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y -= jump_speed
	
	if velocity.x > 0:
		scale.x = 1
	elif velocity.x < 0:
		scale.x = -1
	else:
		scale.x = 1
	
	velocity = move_and_slide(velocity, Vector2.UP)
	

func change_health(value : int) -> void:
	player_health += value
	
	if player_health > player_max_health:
		player_health = player_max_health
	
	if player_health <= 0:
		player_died = true
		queue_free()
	
	emit_signal("health_changed", player_health)

func _attack(inv):
	var equipped = self.get_child(inv)
	var vec = Vector2(12.5, 0.0)
	equipped.position = vec
	equipped.rotation_degrees = 0.0
	yield(get_tree().create_timer(0.25), "timeout")
	equipped.rotation_degrees = oRD
	equipped.position = oVec

func _equip(inv):
	if inv == 2:
		self.get_child(3).visible = false
		self.get_child(3).set_block_signals(true)
	else:
		self.get_child(2).visible = false
		self.get_child(2).set_block_signals(true)
	
	var equipped = self.get_child(inv)
	equipped.visible = true
	equipped.set_block_signals(false)
	currently_equiped = inv

func _addTokens(amount):
	current_tokens += amount
	emit_signal("tokens_changed", current_tokens)
