extends KinematicBody2D

const SPEED = 250
const DAMPENING = 0.9

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var collision_info

onready var bulletBounce = $BulletBounce

func _ready():
	velocity = direction * SPEED


func _physics_process(delta) -> void:
	velocity *= DAMPENING
	# Actual Movement
	collision_info = move_and_collide(velocity * delta)
	
	# Ping Pong Mode
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		velocity *= 0.5
		bulletBounce.play()
	
	if velocity.length() < 5:
		queue_free()
