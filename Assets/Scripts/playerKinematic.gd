extends KinematicBody2D

class_name Player

export (int) var inertia : int = 0
export (float) var mass : float = 0.0
export (float) var friction : float = 0.0
export (float) var gravity : float = 0.0
export (int) var jumpForce : int = 0
export (int) var speed : int = 0
var aceleration = Vector2(0, 0)
var velocity = Vector2(0, 0)
var FloorNormal = Vector2(0, -1)

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if is_on_floor():
		ApplyWhenOnGround()
	else:
		ApplyOutOfGround()
	Jump()
	GetHorizontalInput(delta)
	velocity += aceleration
	velocity.x = clamp(velocity.x, -150, 150)
	print(velocity)
	velocity = move_and_slide(velocity, FloorNormal, false, 4, PI/4, false)
	aceleration = Vector2.ZERO
	for index in get_slide_count():
		var collision : KinematicCollision2D = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBody"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)

func GetHorizontalInput(delta) -> void:
	var direction : int = 0
	if Input.get_action_strength("ui_right"):
		$Body.scale.x = 1
		direction += 1
	if Input.get_action_strength("ui_left"):
		$Body.scale.x = -1
		direction += -1
	if direction != 0:
		AddForce((Vector2(direction, 0).normalized()) * speed)
	else:
		velocity = Vector2(0, velocity.y)

func Jump() -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		AddForce(Vector2(0, -jumpForce))
		#velocity.y += -400

func ApplyWhenOnGround() -> void:
	#AddForce(ApplyFriction())
	AddForce(ApplyGravity())

func ApplyOutOfGround() -> void:
	AddForce(ApplyGravity())

func ApplyFriction() -> Vector2:
	var frictionForce : Vector2 = velocity.normalized() * friction * -1
	frictionForce = Vector2(frictionForce.x, 0)
	return frictionForce

func ApplyGravity() -> Vector2:
	var gravityForce : Vector2 = Vector2(0, gravity)
	gravityForce *= mass
	return gravityForce

func AddForce(force : Vector2) -> void:
	aceleration += force / mass
