extends Position2D

func _physics_process(delta):
	if $"..".flip_h == true:
		self.position.x = -5.5
	else:
		self.position.x = 4
