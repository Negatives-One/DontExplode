extends KinematicBody2D

var motion = Vector2()
var UP = Vector2(0, -1)
var velocidade = 400
const GRAVIDADE = 10
var rot

func _ready():
	pass

func _physics_process(delta):
	rot = $Sprite2.rotation_degrees
	motion.y += GRAVIDADE
	if Input.is_action_pressed("Right1"):
		motion.x = velocidade
	elif Input.is_action_pressed("Left1"):
		motion.x = -velocidade
	else:
		motion.x = 0
	if Input.is_action_just_pressed("Space"):
		motion.y = -400
		
	move_and_slide(motion, UP)
