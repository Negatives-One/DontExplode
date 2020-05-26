extends Node2D
onready var inimigos = $"Inimigos"
var cont = 0

func _ready():
	$musica.play()
	for i in inimigos.get_children():
		cont += 1

func _on_musica_finished():
	$musica.play()
