extends Node2D

var score := 0

func _ready():
	# Configuración inicial
	print("Juego iniciado")

func add_point():
	score += 1
	print("Puntos: ", score)
