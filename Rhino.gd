extends KinematicBody2D

onready var player = $"../KinematicBody2D"

var vel = Vector2(0, 0)
var react_time = 400
var grav = 10
var direction = 0
var dir = 0
var next_dir = 0
var next_dir_time = 0
var attacking = false
var next_jump_time = -1

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func _ready():
	$CollisionShape2D/Line2D.add_point(player.global_position)

func _physics_process(delta):
	headbut()
	$CollisionShape2D/Line2D.set_point_position(1, player.global_position)
	if attacking == false:
		if is_on_floor() == false:
			vel.y += grav
		if player.position.x < self.position.x - 20:
			set_dir(-1)
		elif player.position.x > self.position.x + 20:
			set_dir(1)
		else:
			set_dir(0)
	
		if OS.get_ticks_msec() > next_dir_time:
			dir = next_dir
	
		if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
			if player.position.y < position.y - 8:	
				vel.y = -200
			next_jump_time = -1
	
		vel.x = dir * 100
	
		if player.position.y < position.y - 8 and next_jump_time == -1: 
			next_jump_time = OS.get_ticks_msec() + react_time
	
		move_and_slide(vel, Vector2(0, -1))
		


func headbut():
	var area = $Area2D.get_overlapping_bodies()
	if area.has(player):
		var angle = player.position - self.position
		attacking = true
		
