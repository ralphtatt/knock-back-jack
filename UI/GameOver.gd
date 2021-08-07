extends Control


onready var score = $CenterContainer/VBoxContainer/CenterContainer2/Score

func _ready():
	score.text = "SCORE\n" + str(Global.score + Global.enemies_killed * 8)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://UI/MainMenu.tscn")
