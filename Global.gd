extends Node

var options = {
	"camera_follow_mouse" : false,
	"smoothing_enabled" : false
}



var player
var health

var score
var enemies_killed

func init_game():
	player = null
	health = 5
	
	score = 0
	enemies_killed = 0
