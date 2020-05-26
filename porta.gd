extends Area2D

var entered

func _process(delta):
	if $"..".cont != 0:
		$Sprite.visible = true
		$Sprite2.visible = false
	else:
		$Sprite.visible = false
		$Sprite2.visible = true
	
	if entered == true and Input.is_action_just_pressed("Up1") and $"..".cont == 0:
		get_tree().change_scene("res://Fase2 (1).tscn")
		pass

func _on_Area2D_body_entered(body):
	if body == $"../Camera2D/KinematicBody2D":
		entered = true


func _on_Area2D_body_exited(body):
	if body == $"../Camera2D/KinematicBody2D":
		entered = false
