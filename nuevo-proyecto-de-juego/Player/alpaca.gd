extends CharacterBody2D

# Configuración de movimiento
@export var speed: float = 300.0
@export var jump_force: float = -500.0
@export var gravity: float = 980.0

# Sistema de juego
var lives = 3
var score = 0
var is_dead = false

func _ready():
	# La cámara ya debe estar como hijo de la Alpaca
	pass

func _physics_process(delta):
	if is_dead:
		return
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimiento horizontal (izquierda/derecha)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * speed
		# Voltear sprite según dirección
		if has_node("Sprite"):
			$Sprite.flip_h = direction < 0
	else:
		# Frenar suavemente cuando no hay input
		velocity.x = move_toward(velocity.x, 0, speed * 0.1)
	
	# Saltar (espacio o flecha arriba)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	# Aplicar movimiento
	move_and_slide()
	
	# Detectar caída al vacío
	if global_position.y > 700:
		die()

func collect_item(points = 10):
	score += points
	print("🎉 Puntos: ", score)
	
	# Notificar al Main si existe
	var main = get_node_or_null("/root/Node2D")
	if main and main.has_method("update_score"):
		main.update_score(score)

func die():
	if is_dead:
		return
	
	is_dead = true
	lives -= 1
	print("💔 Vidas restantes: ", lives)
	
	if lives <= 0:
		game_over()
	else:
		# Respawn después de 1 segundo
		await get_tree().create_timer(1.0).timeout
		respawn()

func respawn():
	is_dead = false
	# Volver al inicio o checkpoint
	global_position = Vector2(100, 300)
	velocity = Vector2.ZERO

func game_over():
	print("💀 GAME OVER - Puntos finales: ", score)
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

# Conectar esta función a la señal area_entered del Area2D
func _on_area_2d_area_entered(area):
	if area.is_in_group("collectible"):
		collect_item(10)
		area.queue_free()
