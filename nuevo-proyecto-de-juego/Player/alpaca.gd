extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0
@export var auto_move_speed: float = 120.0  # Velocidad automática hacia adelante

var starting_position = Vector2(400, 300)  # Posición inicial más centrada

func _ready():
	starting_position = global_position
	
	# Asegurar que la cámara está en la posición correcta
	if has_node("Camera2D"):
		var camera = get_node("Camera2D")
		camera.reset_smoothing()  # Resetea el suavizado para empezar correctamente

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	# Movimiento automático hacia la derecha
	velocity.x = auto_move_speed
	
	# Control adicional izquierda/derecha (opcional, para acelerar/frenar)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x += direction * speed * 0.3  # 30% de velocidad extra
		# Voltear sprite según dirección
		$Sprite.flip_h = direction < 0
	
	# Saltar con espacio o flecha arriba
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	# Aplicar movimiento
	move_and_slide()
	
	# Verificar si cayó al vacío (ajusta según tu ventana)
	if global_position.y > 700:
		respawn()

func respawn():
	# Llamar al Main para perder vida
	var main = get_node("/root/Node2D")
	main.lose_life()
	
	# Resetear posición justo adelante de donde cayó (no al inicio)
	global_position.x = global_position.x + 100
	global_position.y = 300
	velocity = Vector2.ZERO

# Esta función se conectará a la señal del Area2D
func _on_area_2d_area_entered(area):
	if area.is_in_group("collectible"):
		# Llamar al Main para sumar puntos
		var main = get_node("/root/Node2D")
		main.collect_bolita()
		# Eliminar la bolita
		area.queue_free()
