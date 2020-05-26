extends Position2D

func _on_Timer_timeout():
	self.global_position.x = rand_range(0, 206)
	self.global_position.y = rand_range(0, 108)
