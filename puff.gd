extends AnimatedSprite

func _ready():
	self.play('puff')

func _on_AnimatedSprite_animation_finished():
	queue_free()
