extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

var velocity = Vector2()
var move_speed = 10 * 16
var gravity = 800
var jump_velocity = -700
var is_grounded

onready var raycasts = $raycasts


func _physics_process(delta):
	_get_input()
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, UP, SLOPE_STOP)

	is_grounded = _check_is_grounded()

	_assign_animation()

func _input(event):
	if Input.is_action_pressed('Space') and is_grounded:
		velocity.y = jump_velocity

func _get_input():
	var move_direction = -int(Input.is_action_pressed('left1')) + int(Input.is_action_pressed('right1'))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		$Sprite.scale.x = move_direction

func _get_h_weight():
	return 0.2 if is_grounded else 0.1

func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _assign_animation():
	var anim = 'idle'

	if !is_grounded:
		anim = 'jump'
	elif velocity.x != 0:
		anim = 'run'

	if $AnimatedSprite.get_animation() != anim:
		$AnimatedSprite.play(anim)
