extends Node2D

# Arrastra aquí las escenas desde el explorador de archivos
@export var platform_scene: PackedScene
@export var collectible_scene: PackedScene

# Configuración del generador
@export var spawn_interval = 2.0  # Segundos entre plataformas
@export var platform_speed = 120.0  # Velocidad de movimiento
@export var min_y = 250  # Altura mínima de spawn
@export var max_y = 500  # Altura máxima de spawn
@export var spawn_x = 1200  # Posición X donde aparecen

var spawn_timer = 0.0
var platforms = []

func _ready():
	# Crear plataformas iniciales para empezar
	for i in range(6):
		spawn_platform(200 + i * 200, false)

func _process(delta):
	# Timer para generar nuevas plataformas
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		# Spawneamos adelante de donde está la alpaca
		var alpaca = get_node_or_null("../Alpaca")
		if alpaca:
			spawn_platform(alpaca.global_position.x + spawn_x, true)
	
	# Limpiar plataformas que quedaron atrás
	for platform in platforms:
		if is_instance_valid(platform):
			var alpaca = get_node_or_null("../Alpaca")
			if alpaca and platform.global_position.x < alpaca.global_position.x - 500:
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
	
	# 70% de probabilidad de que aparezca una bolita
	if randf() < 0.7:
		spawn_collectible(x_pos, y_pos - 70)

func spawn_collectible(x_pos, y_pos):
	if collectible_scene == null:
		print("❌ ERROR: No hay escena de coleccionable asignada")
		return
	
	var collectible = collectible_scene.instantiate()
	collectible.global_position = Vector2(x_pos, y_pos)
	get_parent().add_child(collectible)
