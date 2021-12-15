extends KinematicBody2D

export var max_speed = 300.0
export var acceleration = 500.0
export var friction = 0.97
export var gravity = 9.8
export var jump_speed = 400.0
var velocity = Vector2.ZERO

export var player_health = 10.0
export var player_max_health = 10.0
export var player_died = false
export var player_damage = 1.0
export var player_cur_damage : float

func _physics_process(delta):
	velocity.y += gravity
	
	var input = 0.0
	
	if Input.is_action_pressed("ui_right"):
		input += 1.0
	
	if Input.is_action_pressed("ui_left"):
		input -= 1.0
	
	velocity.x += input * acceleration * delta
	
	if input == 0.0:
		velocity.x  = velocity.x * friction
	
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y -= jump_speed
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _setHealth(t_health):
	player_health = t_health
	if player_health > player_max_health:
		player_health = player_max_health

func _healPlayer(t_health):
	player_health += t_health
	if player_health > player_max_health:
		player_health = player_max_health

func _damagePlayer(t_damage):
	player_health -= t_damage
	if player_health <= 0:
		player_died = true