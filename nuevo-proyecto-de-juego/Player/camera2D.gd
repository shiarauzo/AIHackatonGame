extends Camera2D

@export var target_path: NodePath = "../Alpaca"
@export var follow_speed = 5.0
@export var offset_y = -50  # Offset vertical (ajustar según gustes)

var target: Node2D

func _ready():
	enabled = true
	target = get_node(target_path)
	
	# Posicionar inmediatamente en el target al inicio
	if target:
		global_position = Vector2(target.global_position.x, target.global_position.y + offset_y)

func _process(delta):
	if target:
		# Posición objetivo
		var target_pos = Vector2(target.global_position.x, target.global_position.y + offset_y)
		
		# Seguimiento suave (lerp)
		global_position = global_position.lerp(target_pos, follow_speed * delta)
