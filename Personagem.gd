extends KinematicBody2D

var y = true
var vida = 3
var motion = Vector2()
var up = Vector2(0,-1)
var vetor = [0,0]
var X = 200
var dashing = false
var podeDashar = true 
var diagonalUP = false
var shootUp = true
var velocity
var uncontrol = false
var click
var hit = false
var hitOrien = Vector2()
var ajusteY = true
var lista = []
const SLOPE_STOP = 64
const capsula = preload("res://capsula.tscn")
var tempo
var stopou = false
var stopped = false
var morto = false
var once = true


func _physics_process(delta):
	$Label.set_text(String($"../..".cont))
	var txt = $Label.get_text()
	if txt == '0':
		if once == true:
			$audios/porta.play()
			once = false
		$Label.visible = false
		$check.visible = true
	stop()
	tempo = $cooldown.get_time_left()
	$TextureProgress2.value = tempo
	if vida == 3:
		$TextureProgress.value = 100
		$TextureProgress.set_modulate(Color( 0.5, 1, 0, 1))
	elif vida == 2:
		$TextureProgress.value = 67
		$TextureProgress.set_modulate(Color( 1, 0.84, 0, 1))
	elif vida == 1:
		$TextureProgress.value = 33
		$TextureProgress.set_modulate(Color(0.55, 0, 0, 1))
	elif vida <= 0:
		$TextureProgress.value = 0
		$TextureProgress.set_modulate(Color(0.66, 0.66, 0.66, 1))
	if motion.y > 1:
		ajusteY = true
	if hit == true:
		hitted()
	if NoChao() == false and stopped == false and morto == false:
		motion.y += 10
	if is_on_ceiling():
		motion.y = 0
	if NoChao() == true:
		if ajusteY == true and is_on_floor():
			stopou = false
			motion.y = 0
			ajusteY = false
		uncontrol = false
		
	Movimento()
	Horizontal()
	#Vertical()
	#Dash()
	jump()
	detectY()
	anim()
	shoot()
	velocity = move_and_slide(motion, up, SLOPE_STOP)
	


func enemyDead():
	$cooldown.set_wait_time(0.1)
	$cooldown.start()

func Horizontal():
	if Input.is_action_pressed('Right1'):
		$AnimatedSprite.flip_h = false
		vetor[0] = 1
	elif Input.is_action_pressed('Left1'):
		$AnimatedSprite.flip_h = true
		vetor[0] = -1
	else:
		vetor[0] = 0

func anim():
	if morto == false:
		if NoChao() and vetor[0] != 0:
			$AnimatedSprite.play('run')
		if NoChao() == false and vetor[1] >= lista[0]:
			$AnimatedSprite.play('jump')
		elif NoChao() == false and vetor[1] <= lista[0]:
			$AnimatedSprite.play('fall')
		if NoChao() and vetor[0] == 0:
			$AnimatedSprite.play('idle')
	else: 
		$AnimatedSprite.play('morto')

func detectY():
	lista.append(motion.y)
	if len(lista) > 2:
		lista.pop_front()

		
func jump():
	if Input.is_action_just_pressed('Space') and NoChao() and morto == false:
		$audios/jump.play()
		ajusteY = true
		motion.y += -200

func Movimento():
	if uncontrol == false and Input.is_action_pressed('Left1') and stopped == false and morto == false or uncontrol == false and Input.is_action_pressed('Right1') and stopped == false and morto == false:
		motion.x = lerp(motion.x, vetor[0] * X/2, 0.2)
	elif uncontrol == false:
		motion.x = lerp(motion.x, 0, 0.1)


func NoChao():
	for raycast in $raycasts.get_children():
		if raycast.is_colliding():
			var colider = raycast.get_collider()
			if colider.name == $"../../TileMap".name:
				return true
	return false

func shoot():
	if Input.is_action_just_pressed("Shoot1") and $Sprite/RayCast2D.is_colliding() == false and shootUp == true and NoChao() == false and morto == false:
		$audios/Rlaunch.play()
		uncontrol = true
		shootUp = false
		$cooldown.start()
		#$"../../CanvasLayer/Label/cd".start()
		new_capsule()
		knockback(0,0)
	elif Input.is_action_just_pressed("Shoot1") and $Sprite/RayCast2D.is_colliding() == false and shootUp == true and NoChao() == true and morto == false:
		$audios/Rlaunch.play()
		shootUp = false
		$cooldown.start()
		#$"../../CanvasLayer/Label/cd".start()
		new_capsule()
		knockback(0,0)

func new_capsule():
	var new_capsule = capsula.instance()
	get_parent().call_deferred('add_child', new_capsule)
	new_capsule.position = $"Sprite/Position2D".global_position

func knockback(num, vetorImp):
	if morto == false:
		ajusteY = true
		#tiro
		if num == 0:
			click = get_local_mouse_position().normalized()
			motion = -click * 250
		#explosao missil
		elif num == 1:
			hitOrien = hitOrien.normalized()
			motion = -hitOrien * 250
		#bola de fogo
		elif num == 2:
			for raycast in $raycasts.get_children():
				raycast.enabled = false
			$knockback.start()
			uncontrol = true
			hitOrien = hitOrien.normalized()
			motion = -hitOrien * 100
		elif num == 3:
			motion = -vetorImp * 100

func _on_cooldown_timeout():
	$cooldown.set_wait_time(4)
	shootUp = true
	
func hitted():
	for raycast in $raycasts.get_children():
		raycast.enabled = false
	ajusteY = true
	$knockback.start()
	uncontrol = true
	hit = false
	knockback(1,0)

func hurt():
	vida += -1
	if vida <= 0:
		motion.x = 0
		motion.y = 0
		morto = true
		if y == true:
			$audios/death.play()
			y = false
		$Portal.visible = true
		$Particles2D.emitting = true
		$TempoMorte.start()

func _on_knockback_timeout():
	for i in $raycasts.get_children():
		i.enabled = true

func stop():
	if Input.is_action_just_pressed("Dash") and stopou == false and stopped == false and morto == false:
		$audios/stop.play()
		stopou = true
		stopped = true
		$stopped.start()
		var pos = self.position
		$"../../extase".position = pos
		$"../../extase/Particles2D".emitting = true
		uncontrol = false
		motion.x = 0
		motion.y = 0

func lock():
	$AnimatedSprite2.visible = true
func unlock():
	$AnimatedSprite2.visible = false

func _on_stopped_timeout():
	stopped = false


func _on_TempoMorte_timeout():
		get_tree().reload_current_scene()
