extends KinematicBody2D

class_name Player

var motion = Vector2(0,0);
var Up = Vector2(0,-1)
var stateMachine

func _ready():
	stateMachine  = $AnimationTree
	$AnimationPlayer.play("Run")
	pass

func _physics_process(delta):
	motion.y += 8;
	if is_on_floor():
		motion.y = 8
	if Input.is_action_pressed("ui_left"):
		$Body.scale = Vector2(-1,1)
		motion.x = -100
	elif Input.is_action_pressed("ui_right"):
		$Body.scale = Vector2(1,1)
		motion.x = 100
	else:
		motion.x = 0
	if Input.is_action_pressed("ui_up") and is_on_floor():
		motion.y += -150
	move_and_slide(motion, Up)
	
func ChangeAnimation(SomeState):
	stateMachine.travel("SomeState")
