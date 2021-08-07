extends KinematicBody2D

const Blood = preload("res://Enemy/Blood.tscn")

onready var playerDetection = $PlayerDetection

const MAX_SPEED = 100
const ACCELERATION = 100

var velocity = Vector2.ZERO
var collision_info

enum {
	WANDER,
	CHASE
}

var state = WANDER

func _physics_process(delta):

	match state:
		WANDER:
			if playerDetection.can_see_player():
				state = CHASE
#			velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
		CHASE:
			var player = playerDetection.player
			
			if player:
				aim_at_player()
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = WANDER
	
	collision_info = move_and_collide(velocity * delta)


func _on_Hurtbox_area_entered(_area):
	var blood = Blood.instance()
	get_tree().current_scene.add_child(blood)
	blood.global_position = global_position
	blood.rotation = global_position.angle_to_point(Global.player.global_position)
	Global.enemies_killed += 1
	queue_free()

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE

func aim_at_player():
	look_at(playerDetection.player.global_position)

