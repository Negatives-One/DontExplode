extends Area2D

onready var player = $"../../Camera2D/KinematicBody2D"

func _on_MolaUp_body_entered(body):
	if body == player:
		$AudioStreamPlayer.play()
		$AnimatedSprite.play('uping')
		var hitOrien = Vector2(0, 4)
		player.knockback(3, hitOrien)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == 'uping':
		$AnimatedSprite.play('down')
