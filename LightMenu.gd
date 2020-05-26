extends Light2D
var volta = false

func _physics_process(delta):
	if self.global_position.x > 220 and volta == false:
		volta = true
	if self.global_position.x < -20:
		volta = false
	if volta == true:
		self.global_position.x += -1
	else:
		self.global_position.x += 1
	#if self.global_position.x > 198:
		#self.global_position.x = lerp( self.global_position.x, -1, 0.1)
	#elif self.global_position.x < 0:
		#self.global_position.x = lerp( self.global_position.x, 207, 0.1)

