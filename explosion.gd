extends AnimatedSprite

func _ready(): 
	$AudioStreamPlayer.play()
	self.play("explodir")
	if $'..'.name != 'Node2D':
		$"../KinematicBody2D".unlock()
	
func _on_AnimatedSprite_animation_finished():
	if $'..'.name == 'Node2D':
		$"../TextureButton".go = true
	queue_free()
