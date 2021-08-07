extends CPUParticles2D

var player_detected : bool = false

func _on_DetectPlayer_body_entered(body) -> void:
	player_detected = true
