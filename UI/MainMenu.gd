extends Control

func _process(_delta):
	Global.init_game()
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Level/SceneBase.tscn")
