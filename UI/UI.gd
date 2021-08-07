extends Control

onready var healthBar = $HealthBar

func _ready():
	pass

func _process(delta):
	healthBar.value = Global.health
