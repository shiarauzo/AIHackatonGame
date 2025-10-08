extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

var starting_position = Vector2(100, 200)

func _ready():
	starting_position = global_position

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
	
		$Sprite.flip_h = direction < 0
	else:
		velocity.x = 0
	
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	
	move_and_slide()
	

	if global_position.y > 700:
		respawn()

func respawn():

	var main = get_node("/root/Node2D")
	main.lose_life()
	
	global_position = starting_position
	velocity = Vector2.ZERO


func _on_area_2d_area_entered(area):
	if area.is_in_group("collectible"):
	
		var main = get_node("/root/Node2D")
		main.collect_bolita()
		area.queue_free()
