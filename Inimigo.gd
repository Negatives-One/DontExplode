extends KinematicBody2D

onready var player = $"../../Camera2D/KinematicBody2D"
var ball = preload("res://bolaFogo.tscn")
var hit = false
var hitOrien
var frame = 'a'
var anim
var only = true
var pAtacar = true
var changed = false

func _physics_process(delta):
	if hit == true:
		morte()
	anim = $AnimatedSprite.get_animation()
	#frame = $AnimatedSprite.get_frame()

	#print(anim, frame)
	only = true
	if pAtacar == true:
		radar()
		
	if anim == 'attack' and frame == 'ok':
		$AnimatedSprite.get_frame()
		new_fireBall()
		$Timer.start()
		pAtacar = false

	if player.position.x < self.position.x:
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = 2
	else:
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = -2
	frame = 'a'


func new_fireBall():
	var new_ball = ball.instance()
	get_parent().call_deferred('add_child', new_ball)
	new_ball.position = $"AnimatedSprite/Position2D".global_position


func radar():
	var a = $Area2D2.get_overlapping_bodies()
	if a.has(player) == true:
		if changed == false:
			$Area2D2/CollisionShape2D.apply_scale(Vector2(5,5))
			var target = $"../../Camera2D"
			var source = self
			$"..".remove_child(source)
			target.add_child(source)
			changed = true
		$AnimatedSprite.play('attack')

func _on_Timer_timeout():
	pAtacar = true
	only = true



func _on_AnimatedSprite_animation_finished():
	
	if pAtacar == false:
		$AnimatedSprite.play('idle')


func _on_AnimatedSprite_frame_changed():
	var name = $AnimatedSprite.get_animation()
	var socorro = $AnimatedSprite.get_frame()
	if name == 'attack' and socorro == 3:
		frame = 'ok'

func morte():
	$"../..".cont += -1
	queue_free()
	pass

func _on_Area2D_body_entered(body):
	if body == player:
		var x = player.global_position - self.global_position
		player.hitOrien = Vector2(-x.x, -x.y)
		player.knockback(2, 0)

func lock():
	$CollisionShape2D/AnimatedSprite2.visible = true
func unlock():
	$CollisionShape2D/AnimatedSprite2.visible = false
