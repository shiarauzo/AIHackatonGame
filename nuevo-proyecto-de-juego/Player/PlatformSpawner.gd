extends Node2D

@export var platform_scene: PackedScene
@export var collectible_scene: PackedScene


@export var spawn_interval = 2.0  
@export var platform_speed = 120.0 
@export var min_y = 250  
@export var max_y = 500 
@export var spawn_x = 1200 

var spawn_timer = 0.0
var platforms = []

func _ready():
	
	for i in range(6):
		spawn_platform(200 + i * 200, false)

func _process(delta):
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_platform(spawn_x, true)
	
	for platform in platforms:
		if is_instance_valid(platform):
			platform.global_position.x -= platform_speed * delta
			
			if platform.global_position.x < -100:
				platform.queue_free()
				platforms.erase(platform)

func spawn_platform(x_pos, with_random_y = true):
	if platform_scene == null:
		print("❌ ERROR: No hay escena de plataforma asignada")
		return
	
	var platform = platform_scene.instantiate()
	var y_pos = randf_range(min_y, max_y) if with_random_y else 400
	platform.global_position = Vector2(x_pos, y_pos)
	get_parent().add_child(platform)
	platforms.append(platform)
	
	if randf() < 0.7:
		spawn_collectible(x_pos, y_pos - 70)

func spawn_collectible(x_pos, y_pos):
	if collectible_scene == null:
		print("❌ ERROR: No hay escena de coleccionable asignada")
		return
	
	var collectible = collectible_scene.instantiate()
	collectible.global_position = Vector2(x_pos, y_pos)
	get_parent().add_child(collectible)
