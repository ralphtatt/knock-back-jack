extends Area2D
 
var invincible = false setget set_invincible

onready var timer = $InvTimer

signal invincibillity_started
signal invincibillity_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibillity_started")
	else:
		emit_signal("invincibillity_ended")
	

func start_invincibillity(duration):
	self.invincible = true
	timer.start(duration)


func _on_Hurtbox_invincibillity_started():
	set_deferred("monitorable", false)
	

func _on_Hurtbox_invincibillity_ended():
	monitorable = true




func _on_InvTimer_timeout():
	self.invincible = false
