extends Area2D
var hitOrien
onready var player = $"../../Camera2D/KinematicBody2D"
func _on_Area2D_body_entered(body):
	if body == player:
		for i in range(3):
			player.hurt()

