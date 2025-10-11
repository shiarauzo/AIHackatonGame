extends Node2D

@export var platform_scene: PackedScene
@export var collectible_scenes: Array[PackedScene] = []

# Configuración del nivel
@export var platforms_distance = 300  # Distancia entre plataformas
@export var min_y = 200
@export var max_y = 500
@export var level_length = 5000  # Longitud total del nivel

var platforms = []

func _ready():
	if platform_scene == null:
		push_error("⚠️ ERROR: Asigna 'platform_scene' en el Inspector del PlatformSpawner")
		return
	
	generate_level()

func generate_level():
	# Generar plataformas estáticas desde el inicio
	var current_x = 0
	
	# Piso inicial largo (para empezar)
	spawn_platform(0, 550, 800)  # Plataforma larga de inicio
	current_x = 800
	
	# Generar plataformas hasta el final del nivel
	while current_x < level_length:
		var platform_width = randf_range(150, 400)  # Ancho variable
		var y_pos = randf_range(min_y, max_y)
		
		spawn_platform(current_x, y_pos, platform_width)
		
		# 60% probabilidad de comida
		if randf() < 0.6 and not collectible_scenes.is_empty():
			spawn_collectible(current_x + platform_width/2, y_pos - 80)
		
		# Próxima plataforma
		var gap = randf_range(100, 300)  # Distancia del salto
		current_x += platform_width + gap
	
	print("✅ Nivel generado: ", platforms.size(), " plataformas")

func spawn_platform(x_pos, y_pos, width = 200):
	if platform_scene == null:
		return
	
	var platform = platform_scene.instantiate()
	platform.global_position = Vector2(x_pos + width/2, y_pos)
	
	# Si la plataforma tiene un sprite, escalarla al ancho deseado
	if platform.has_node("Sprite2D"):
		var sprite = platform.get_node("Sprite2D")
		var texture_width = sprite.texture.get_width() if sprite.texture else 64
		sprite.scale.x = width / texture_width
	
	get_parent().add_child(platform)
	platforms.append(platform)

func spawn_collectible(x_pos, y_pos):
	if collectible_scenes.is_empty():
		return
	
	var random_food = collectible_scenes[randi() % collectible_scenes.size()]
	var collectible = random_food.instantiate()
	collectible.global_position = Vector2(x_pos, y_pos)
	get_parent().add_child(collectible)
