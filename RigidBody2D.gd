extends KinematicBody2D

var click
var cooldown = true
var gravity = 10
var motion = Vector2()
var up = Vector2(0, -1)
var velocity
var spawn = true
var missile = preload("res://homing.tscn")
onready var player = $"../KinematicBody2D"

func _physics_process(delta):
	if is_on_floor() == false:
		motion.y += gravity
	if spawn == true:
		$Timer.start()
		click = player.get_local_mouse_position().normalized()
		motion += click*200
		spawn = false
	if is_on_floor():
		motion.x = lerp(motion.x, 0, 0.2)
	velocity = move_and_slide(motion, up)


func _on_Timer_timeout():
	new_missile()
	queue_free()
	pass
	
func new_missile():
	var new_missile = missile.instance()
	get_parent().call_deferred("add_child", new_missile)
	new_missile.position = self.global_position

func _on_Cooldown_timeout():
	cooldown = true
	spawn = true
