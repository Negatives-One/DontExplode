extends KinematicBody2D

var Touched = false
var morto = false
var CanStop = true
var CanShoot = true
onready var ShieldExplosion = $Shield/ShieldExplosion.get_children()
onready var NormalRotation = self.rotation
onready var RaycastGround = $RaycastsGround.get_children()
var defensing = false
var goShield = false
var stop = false
var uncontrol = false
var mouse
const Capsule = preload("res://scenes/Projectiles/capsula.tscn")
const Extase = preload("res://scenes/Effects/Extase.tscn")















var motion = Vector2()
var DirPlayer = [0, 0]
export (int) var VidaPlayer = 3
export (int) var MovementPower = 250
export (int) var GravityForce = 800
export (int) var JumpForce = -300
export (int) var VidaShield = 3
export (float) var UncontrolRotation = 0.174533
var Velocity

func _ready():
	pass

func _process(_delta):
	testscript.chao = Floor()
	testscript.anim = $AnimatedSprite.get_animation()
	testscript.dir = DirPlayer

func _physics_process(delta):
	if morto == false:
		if stop == false:
			Gravity(delta)
			Jump()
			if uncontrol == false:
				Movimento()
			if defensing == false:
				Shoot()
		SpinUncontrol()
		HUD_Update()
		Horizontal()
		Vertical()
		GroundTouched()
		Animations()
		Gun()
		Shield()
	Velocity = move_and_slide(motion, Vector2.UP)


func Horizontal():
	if Input.is_action_pressed("Direita"):
		$AnimatedSprite.flip_h = false
		DirPlayer[0] = 1
	elif Input.is_action_pressed("Esquerda"):
		$AnimatedSprite.flip_h = true
		DirPlayer[0] = -1
	else:
		DirPlayer[0] = 0

func Vertical():
	if motion.y == 1:
		DirPlayer[1] = 0
	elif motion.y < 1:
		DirPlayer[1] = -1
	elif motion.y > 1:
		DirPlayer[1] = 1

func Gravity(delta):
	if not Floor():
		motion.y += GravityForce * delta
	else:
		uncontrol = false
		if motion.y > 1:
			motion.y = 1

func GroundTouched():
	if Floor() and Touched == false:
		Touched = true
		uncontrol = false
		CanStop = true
	if not Floor():
		Touched = false

func Floor():
	var raycasts = [0, 0, 0]
	for i in range(len(RaycastGround)):
		raycasts[i] = RaycastGround[i].is_colliding()
		if raycasts[i] == true:
			uncontrol = false
			return true
	return false

func Jump():
	if Input.is_action_just_pressed('Space') and Floor():
		motion.y += JumpForce

func Movimento():
	if uncontrol == true:
		return
	motion.x = lerp(motion.x, DirPlayer[0] * MovementPower/2, 0.2)

func Animations():
	if Floor() and DirPlayer[0] != 0:
		$AnimatedSprite.play('run')
	if Floor() == false and DirPlayer[1] == -1:
		$AnimatedSprite.play('jump')
	elif Floor() == false and DirPlayer[1] == 1:
		$AnimatedSprite.play('fall')
	if Floor() and DirPlayer[0] == 0 and DirPlayer[1] == 0:
		$AnimatedSprite.play('idle')

func Gun():
	$Gun.rotation = get_local_mouse_position().angle()

func Shoot():
	if Input.is_action_just_released("LClick") and CanShoot:
		CanShoot = false
		$CooldownShoot.start()
		if Floor() == false:
			uncontrol = true
		motion = -MouseAngle() * 350
		PlayerVars.PlayerClick = (self.global_position - get_global_mouse_position()).normalized()
		NewCapsule()

func HUD_Update():
	$CanvasLayer/TextureProgress.value = $CooldownShoot.time_left

func Hitted():
	for i in RaycastGround:
		i.enabled = false
	uncontrol = true
	$UncontrolTime.start()

func NewCapsule():
	var new_capsule = Capsule.instance()
	get_parent().call_deferred('add_child', new_capsule)
	new_capsule.position = $"Gun/Position2D".global_position

func MouseAngle():
	mouse = get_local_mouse_position()
	mouse = mouse.normalized()
	return mouse


func Shield():
	if VidaShield == 3:
		$Shield/Sprite.self_modulate = Color( 0, 1, 0, 1 )
	elif VidaShield == 2:
		$Shield/Sprite.self_modulate = Color( 1, 1, 0, 1 )
	elif VidaShield == 1:
		$Shield/Sprite.self_modulate = Color( 1, 0, 0, 1 )

	if Input.is_action_just_pressed("RClick"):
		if CanStop == true:
			CanStop = false
			motion.x = 0
			motion.y = 1
			stop = true
			uncontrol = false
			$Extase/AirTime.start()
			$Extase.emitting = true
		$ShieldDelay.start()

	if VidaShield <= 0:
		goShield = false
		defensing = false
		$Shield/Sprite.visible = false
		$Shield/CollisionPolygon2D.disabled = true
		return

	if Input.is_action_pressed("RClick"):
		defensing = true
		if goShield == true:
			$Shield/Sprite.visible = true
			$Shield/CollisionPolygon2D.disabled = false
			$Shield.position = MouseAngle() * 12
			$Shield/ShieldExplosion.position = MouseAngle() * 1.5
			$Shield/ShieldExplosion.rotation_degrees = MouseAngle().angle() * 57.2958
			$Shield/Sprite.rotation = MouseAngle().angle() +1.5708
			$Shield/CollisionPolygon2D.rotation_degrees = MouseAngle().angle() * 57.2958
	elif Input.is_action_just_released("RClick"):
		goShield = false
		defensing = false
		$Shield/Sprite.visible = false
		$Shield/CollisionPolygon2D.disabled = true

func ShieldHit(Damage):
	for i in ShieldExplosion:
		i.emitting = true
	VidaShield += -Damage

func LifeSystem(Damage):
	VidaPlayer += -Damage
	if VidaPlayer == 2:
		$Vidas/Sprite3.visible = false
	elif VidaPlayer == 1:
		$Vidas/Sprite2.visible = false
	elif VidaPlayer == 0:
		morto = true
		get_tree().reload_current_scene()
	$AnimatedSprite/AnimationPlayer.play("Damage")
	

func _on_ShieldDelay_timeout():
	if defensing:
		goShield = true


func _on_AirTime_timeout():
	if Floor():
		CanStop = true
	stop = false


func _on_RegenShield_timeout():
	if VidaShield < 3:
		VidaShield += 1
	if VidaShield < 0:
		VidaShield = 1

func SpinUncontrol():
	if uncontrol == true:
		if PlayerVars.PlayerClick.x > 0:
			$AnimatedSprite.rotation += UncontrolRotation
		else:
			$AnimatedSprite.rotation += -UncontrolRotation
	else:
		$AnimatedSprite.rotation = NormalRotation

func _on_CooldownShoot_timeout():
	CanShoot = true


func _on_UncontrolTime_timeout():
	for i in RaycastGround:
		i.enabled = true
