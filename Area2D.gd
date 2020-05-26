extends Area2D

export var speed = 100
export var steer_force = 40
export var grouth = 1
var spawn = true
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
onready var player = $"../KinematicBody2D"
onready var target = $"../KinematicBody2D"
var explosao = preload("res://explosion.tscn")

func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	if target == player:
		player.lock()
	else:
		if is_instance_valid(target) == false:
			pass
		else:
			target.lock()
	if $troca.is_colliding():
		var alvo = $troca.get_collider()
		if alvo.is_in_group("explodivel"):
			if alvo.is_in_group('Inimigo'):
				target.unlock()
			target = alvo
	if is_instance_valid(target) == false:
		target = player
	if spawn == true:
		$explode.start()
		spawn = false
	else:
		$troca.enabled = true
	var colider = $RayCast2D.get_collider()
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	if colider == target:
		position += velocity * delta * grouth
		grouth += 0.012
	else:
		position += velocity * delta * grouth
		grouth = lerp(grouth, 1, 0.05)

func explode():
	
	var explode = explosao.instance()
	get_parent().call_deferred("add_child", explode)
	explode.position = self.global_position
	queue_free()

func _on_explode_timeout():
	target.unlock()
	explode()


func _on_Area2D_body_entered(body):
	if body == player:
		player.hurt()
		player.unlock()
	target.hitOrien = self.position - target.position 
	target.hitOrien = Vector2(target.hitOrien[0], target.hitOrien[1])
	if body.is_in_group("explodivel"):
		if body.is_in_group('Inimigo'):
			player.enemyDead()
		body.hit = true
		explode()
	
