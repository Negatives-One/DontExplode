extends RayCast2D

var rot
var mouse
onready var player = $"../../../Camera2D/KinematicBody2D"
var achou = false
func _process(delta):
	
	rot = player.position.angle()
	self.look_at(player.position)
	self.rotation = self.rotation - 35
