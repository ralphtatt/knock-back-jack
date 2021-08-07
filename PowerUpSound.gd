extends Node2D


func _ready():
	pass


func _on_AudioStreamPlayer_finished():
	queue_free()
