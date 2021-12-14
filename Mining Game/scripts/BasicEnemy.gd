extends KinematicBody2D

export var max_speed = 50.0
export var acceleration = 200.0
export var gravity = 9.8
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var randomNum = 0
var direction = 0
const TIME_PERIOD = 0.01
var time = 0

export var basicE_health = 3
export var basicE_damage = 1
export var basicE_died = false

func _physics_process(delta):
	velocity.y += gravity
	
	if randomNum == 0:
		direction += 1.0
	else:
		direction -= 1.0
	
	velocity.x += direction * acceleration * delta
	
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	time += delta
	
	if time > TIME_PERIOD:
		rng.randomize()
		randomNum = rng.randi_range(0, 1)
		time = 0

func _damageBasicE(t_damage):
	basicE_health -= t_damage
	if basicE_health <= 0:
		basicE_died = true
