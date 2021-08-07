extends KinematicBody2D

const SPEED = 64
const DAMPENING = 0.67
var KNOCKBACK_MULT = 4

var velocity = Vector2.ZERO
var vel_vector = Vector2.ZERO
var knock_vector = Vector2.ZERO
var knockback = Vector2.ZERO

var aiming_direction = Vector2.ZERO

var collision_info

var firing = false 
var powered_up = true

const Bullet = preload("res://Player/Bullet.tscn")


onready var gunSpawnPoint = $GunSpawnPoint
onready var powerUpTimer = $PowerupTimer

onready var hurtBox = $Hurtbox
onready var animationPlayer = $AnimationPlayer

onready var blastSound = $Blast
onready var bounceSound = $Bounce
onready var hurtSound = $Hurt

func _ready():
	Global.player = self

func _exit_tree():
	Global.player = null


func get_input_vector() -> Vector2:
	vel_vector = Vector2.ZERO
	if Input.is_action_pressed('right'):
		vel_vector.x += 1
	if Input.is_action_pressed('left'):
		vel_vector.x -= 1
	if Input.is_action_pressed('down'):
		vel_vector.y += 1
	if Input.is_action_pressed('up'):
		vel_vector.y -= 1
	
	return vel_vector.normalized()

func get_knowback_vector() -> Vector2:
	knock_vector = get_global_mouse_position().direction_to(global_position)
	return knock_vector


func _physics_process(delta) -> void:
	if Global.health < 1:
		player_dead()
	#TODO: This is a mess!!!
	var user_input = get_input_vector()
	
	# Player Direction
	aiming_direction = get_global_mouse_position()
	look_at(aiming_direction)
	
	# if not firing, or user is trying to take control and slower speed
	if not firing or (user_input and velocity.length() < 50):
		velocity = user_input * SPEED
		firing = false
		
	if velocity.length() < 5:
		firing = false
	
	# Firing Calculations 
	if Input.is_action_pressed("fire") and not firing:
		firing = true
		velocity = get_knowback_vector() * SPEED * KNOCKBACK_MULT
		create_blast()
		
	# Actual Movement
	collision_info = move_and_collide(velocity * delta)

	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		velocity *= DAMPENING
		if firing:
			bounceSound.play()
	
	# Extra dampening calculations
	if velocity.length() < 100 and firing:
		velocity *= DAMPENING

func create_blast() -> void:
	var angles
	if not powered_up:
		angles = [0, PI/6, -PI/6]
	else:
		angles = [0, PI/6, -PI/6, PI/3, -PI/3]
	for shot_angle in angles:
		create_bullet(shot_angle)
	blastSound.play()

func create_bullet(angle_rotation=0) -> void:
	var bullet = Bullet.instance()
	bullet.global_position = gunSpawnPoint.global_position
	bullet.direction = gunSpawnPoint.global_position.direction_to(aiming_direction).rotated(angle_rotation)
	get_parent().add_child(bullet)


func start_power_up():
	powered_up = true
	powerUpTimer.start()


func player_hit():
	if not hurtBox.invincible:
		Global.health -= 1
		var time = 1.5 if powered_up else 1
		hurtBox.start_invincibillity(time)
		hurtSound.play()


func player_dead():
	get_tree().change_scene("res://UI/GameOver.tscn")

func _on_PowerupTimer_timeout():
	powered_up = false


func _on_Hurtbox_area_shape_entered(area_id, area, area_shape, local_shape):
	player_hit()

	
func _on_Hurtbox_invincibillity_started():
	animationPlayer.play("invincible")

func _on_Hurtbox_invincibillity_ended():
	animationPlayer.stop(true)
