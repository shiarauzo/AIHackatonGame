extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -400.0
const GRAVITY = 900.0

@onready var sprite = $Sprite  

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		sprite.play("walk")
		sprite.flip_h = direction < 0
	else:
		sprite.play("idle")


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		sprite.play("jump")

	move_and_slide()
