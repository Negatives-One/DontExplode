extends Position2D

func _on_Timer_timeout():
	self.global_position.x = rand_range(-5, 134)
	self.global_position.y = rand_range(-3, 77)