extends RigidBody2D

var velocity : Vector2 = Vector2()
export (float) var aceleration : float = 300
export (float) var maxSpeed : float = 500
var playerTransform


func _ready():
	pass

func _process(_delta):
	GetInput()
	pass

func _integrate_forces(state):
	playerTransform = state.get_transform()
	set_applied_force(velocity);
	if state.linear_velocity.x > maxSpeed:
		state.linear_velocity.x = (state.linear_velocity.normalized()).x * maxSpeed
	pass

func GetInput() -> void:
	if Input.is_action_pressed("ui_right"):
		$Body.scale.x = 1
		velocity = Vector2(maxSpeed, 0)
	elif Input.is_action_pressed("ui_left"):
		$Body.scale.x = -1
		velocity = Vector2(-maxSpeed, 0)
	else:
		velocity = Vector2(0, 0)
	if Input.is_action_just_pressed("ui_up"):
		apply_central_impulse(Vector2(0, 3000))
	pass

