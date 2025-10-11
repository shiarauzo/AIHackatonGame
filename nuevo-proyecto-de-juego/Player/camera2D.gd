extends Camera2D

@export var alpaca: Node2D
@export var fixed_y_offset = -100.0
@export var smooth_speed = 5.0

func _ready():
	position_smoothing_enabled = false
	position.y = fixed_y_offset

func _process(delta):
	if alpaca:
		var target_x = alpaca.global_position.x
		position.x = lerp(position.x, target_x, smooth_speed * delta)
		position.y = fixed_y_offset
