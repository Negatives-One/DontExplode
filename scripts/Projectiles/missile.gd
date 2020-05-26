extends Area2D

export var speed = 125
export var steer_force = 40
export var grouth = 1
var spawn = true
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
onready var player = $"../Player"
onready var target = $"../Player"
const explosao = preload("res://scenes/Effects/ParticleExplosion.tscn")

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

func _ready():
	testscript.player = player

func _physics_process(delta):
	if target == player:
		pass
		#player.lock()
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
	testscript.colider = colider
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
#	var explodidos = $explosao.get_overlapping_bodies()
#	for i in explodidos:
#		var dist = self.global_position.distance_to(i.global_position)
#		var vector = (self.global_position - i.global_position).normalized()
#		print(dist)
#		if dist < 11:
#			i.LifeSystem(1)
#		var force = (-vector * 600) / (dist/3)
#		print(force)
#		i.uncontrol = true
#		i.motion = force
	queue_free()

func _on_explode_timeout():
	explode()

func ExplosionImpulse():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group('Target'):
		var vector = (body.global_position - self.global_position).normalized()
		if body.is_in_group('Shield'):
			player.ShieldHit(3)
			queue_free()
			return
		else:
			if body.is_in_group('Player'):
				body.uncontrol = true
				body.Hitted()
				body.motion = vector * 350
		explode()
