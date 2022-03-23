extends KinematicBody2D

export var max_speed = 5.0
export var gravity = 9.8
var velocity = Vector2.ZERO
var direction = -1
var walk = true

export var MiniBossE_health = 50
export var MiniBossE_damage = 25
export var MiniBossE_died = false

const TIME_PERIOD = 1
var time = 0

func _ready():
	pass # Replace with function body.



func _process(delta):
	move_character(delta)

func move_character(delta):
	
	if walk:
		velocity.y += gravity
		
		velocity.x += direction * max_speed * delta
		
		velocity = move_and_slide(velocity, Vector2.UP)
		
		if is_on_wall():
			turn_around()
	else:
		time += delta
		if time > TIME_PERIOD:
			time = 0
			end_of_hit()

func _damageE(t_damage):
	MiniBossE_health -= t_damage
	if MiniBossE_health <= 0:
		MiniBossE_died = true
		queue_free()

func turn_around():
	if is_on_floor():
		direction *= -1
		scale.x = -scale.x

func hit():
	$AttackDetector.monitoring = true
	walk = false

func end_of_hit():
	$AttackDetector.monitoring = false
	start_walking()

func start_walking():
	walk = true


func _on_PlayerDetector_body_entered(body):
	hit()


func _on_AttackDetector_body_entered(body):
	if body.is_in_group("player"):
		body.change_health(-MiniBossE_damage)
