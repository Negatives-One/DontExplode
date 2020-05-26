extends KinematicBody2D

var click
var cooldown = true
var gravity = 1000
var motion = Vector2()
var up = Vector2(0, -1)
var colision
var touched = false
var missile = preload("res://scenes/Projectiles/missile.tscn")
onready var player = $"../Player"

func _ready():
	click = PlayerVars.PlayerClick
	motion += -click*300

func _physics_process(delta):
	if is_on_floor() == false:
		motion.y += gravity * delta
	else:
		motion.y = lerp(motion.y, 0, 0.2)
	if is_on_floor():
		motion.x = lerp(motion.x, 0, 0.1)
		if touched == false:
			touched = true
			$Timer.start()
	colision = move_and_slide(motion, up)


func _on_Timer_timeout():
	new_missile()
	queue_free()

func new_missile():
	var new_missile = missile.instance()
	get_parent().call_deferred("add_child", new_missile)
	new_missile.position = self.global_position


func _on_NotGroundTouched_timeout():
	new_missile()
	queue_free()
