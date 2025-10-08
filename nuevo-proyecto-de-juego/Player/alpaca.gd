extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # resetea al tocar el piso

	# Movimiento horizontal con flechas
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = 0  # se queda quieta si no se pulsa nada

	# Saltar
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	# Aplicar movimiento
	move_and_slide()
