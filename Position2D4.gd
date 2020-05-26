extends Position2D

func _physics_process(delta):
	self.position.x = $"../KinematicBody2D".position.x
	self.position.y = $"../KinematicBody2D".position.y - 26.5
