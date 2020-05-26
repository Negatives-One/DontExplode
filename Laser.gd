extends Area2D

var hit = false
var orien
onready var player = $"../../Camera2D/KinematicBody2D"
var puff = preload("res://darkPuff.tscn")

func _ready():
	$AudioStreamPlayer2D.play()
	var target = $"../.."
	var source = self
	$"..".remove_child(source)
	target.add_child(source)
	orien = player.global_position - self.global_position
	
	
func _physics_process(delta):
	if hit == true:
		pass
	else:
		self.position += orien.normalized() * 4

func _on_Laser_body_entered(body):
	if body == player:
		player.hurt()
		hit = true
		new_puff()
		var x = player.global_position - self.global_position
		player.hitOrien = Vector2(-x.x, 0)
		player.knockback(2, 0)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func new_puff():
	var new_puff = puff.instance()
	get_parent().call_deferred('add_child', new_puff)
	new_puff.position = self.global_position

func _on_AnimatedSprite_animation_finished():
	queue_free()
