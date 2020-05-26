extends Particles2D

func _ready():
	$AudioStreamPlayer.play()
	self.emitting = true
	$Shards.emitting = true
	$Smoke1.emitting = true
	$Smoke2.emitting = true

func _on_AudioStreamPlayer_finished():
	if $'..'.name == 'Menu':
		$"../ColorRect/PlayButton".go = true
	queue_free()


func _on_Finished_timeout():
	if $'..'.name != 'Menu':
		var target = $"../../.."
		var source = self
		$"..".remove_child(source)
		target.add_child(source)
