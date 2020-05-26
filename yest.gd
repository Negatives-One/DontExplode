extends Node2D

func _process(_delta):
	$Label.text = str($"/root/testscript".dir)
	$Label2.text = str($"/root/testscript".chao)
	$Label3.text = str($"/root/testscript".anim)
	$Label4.text = str(Engine.get_frames_per_second())
	$Label5.text = str(testscript.player, '  ', testscript.colider)
