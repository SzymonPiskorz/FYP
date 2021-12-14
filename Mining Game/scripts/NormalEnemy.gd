extends KinematicBody2D

export var max_speed = 100.0
export var acceleration = 200.0
export var gravity = 9.8
export var jump_speed = 250.0
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var randomNum = 0
var direction = 0
const TIME_PERIOD = 0.01
var time = 0

export var normalE_health = 8
export var normalE_max_health = 8
export var normalE_damage = 3
export var normalE_died = false

func _physics_process(delta):
	velocity.y += gravity
	
	if randomNum == 0:
		direction += 1.0
	else:
		direction -= 1.0
	
	velocity.x += direction * acceleration * delta
	
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)
	
	if is_on_wall() and is_on_floor():
		_jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	time += delta
	
	if time > TIME_PERIOD:
		rng.randomize()
		randomNum = rng.randi_range(0, 1)
		time = 0

func _jump():
	velocity.y -= jump_speed

func _damageNormalE(t_damage):
	normalE_health -= t_damage
	if normalE_health <= 0:
		normalE_died = true

func _healNormalE(t_health):
	normalE_health += t_health
	if normalE_health > normalE_max_health:
		normalE_health = normalE_max_health
