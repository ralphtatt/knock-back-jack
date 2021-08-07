extends Node2D

const PowerUpSound = preload("res://PowerUps/PowerUpSound.tscn")

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if not Global.health < 5:
		return
	Global.health += 1
	var powerUpSound = PowerUpSound.instance()
	get_parent().add_child(powerUpSound)
	queue_free()
