extends KinematicBody2D

export var max_speed = 100.0
export var acceleration = 200.0
export var gravity = 9.8
export var jump_speed = 250.0
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var randomNum = 0
var direction = -1
const TIME_PERIOD = 0.01
var time = 0

export var normalE_health = 15
export var normalE_max_health = 15
export var normalE_damage = 10
export var normalE_died = false

func _physics_process(delta):
	velocity.y += gravity
	
	velocity.x += direction * acceleration * delta
	
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)
	
	if is_on_wall() and is_on_floor():
		_jump()
	
	if velocity.x < 0:
		get_node("Sprite").flip_h = false
	elif velocity.x > 0:
		get_node("Sprite").flip_h = true
	else:
		get_node("Sprite").flip_h = false
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	time += delta
	
	if time > TIME_PERIOD:
		turn_around()
		time = 0

func _jump():
	velocity.y -= jump_speed
	
func turn_around():
	if is_on_floor():
		direction *= -1
		#scale.x = -scale.x
		get_node("Sprite").flip_h = !get_node("Sprite").flip_h
		get_node("AttackShape").scale.x = -1*get_node("AttackShape").scale.x

func _damageE(t_damage):
	normalE_health -= t_damage
	if normalE_health <= 0:
		normalE_died = true
		queue_free()

func _heal(t_health):
	normalE_health += t_health
	if normalE_health > normalE_max_health:
		normalE_health = normalE_max_health


func _on_AttackShape_body_entered(body):
	if body.is_in_group("player"):
		body.change_health(-normalE_damage)
