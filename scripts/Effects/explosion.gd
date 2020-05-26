extends AnimatedSprite

func _ready(): 
	$AudioStreamPlayer.play()
	self.play("explodir")
	if $'..'.name != 'Menu':
		pass
	
func _on_AnimatedSprite_animation_finished():
	self.visible = false
	if $'..'.name == 'Menu':
		$"../ColorRect/PlayButton".go = true


func _on_AudioStreamPlayer_finished():
		queue_free()
