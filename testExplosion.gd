extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("LClick"):
		$Main.emitting = true
		$Main/Shards.emitting = true
		$Main/Smoke1.emitting = true
		$Main/Smoke2.emitting = true
