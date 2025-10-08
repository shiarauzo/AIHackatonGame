extends Node2D

var score := 0
var lives := 3

@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel

func _ready():
	print("🎮 Juego iniciado")
	print("Vidas: ", lives)
	update_ui()

func collect_bolita():
	score += 10
	update_ui()
	print("✨ ¡Bolita recogida! Puntos: ", score)

func lose_life():
	lives -= 1
	update_ui()
	print("💔 ¡Perdiste una vida! Vidas restantes: ", lives)
	
	if lives <= 0:
		game_over()

func update_ui():
	score_label.text = "Puntos: " + str(score)
	lives_label.text = "❤️ " + str(lives)

func game_over():
	print("☠️ ¡GAME OVER!")
	await get_tree().create_timer(2.0).timeout

	get_tree().reload_current_scene()
