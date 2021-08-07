extends Camera2D


onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

var target
var mid_x
var mid_y
var mouse_position

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x

var interpolate_val = 10

func _physics_process(delta):
	self.smoothing_enabled = Global.options.smoothing_enabled
	
	if Global.options.camera_follow_mouse:
		mouse_position = get_global_mouse_position()
		target = Global.player.global_position 
		mid_x = (target.x + mouse_position.x) / 2
		mid_y = (target.y + mouse_position.y) / 2

		global_position = global_position.linear_interpolate(Vector2(mid_x,mid_y), interpolate_val * delta) 
