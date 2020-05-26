extends TextureButton
var go = false
var change_success
var only = false

func _process(_delta):
	if go == true:
		change_success = get_tree().change_scene("res://yest.tscn")
func _on_TextureButton_pressed():
	if not only:
		only = true
		$"../../Area2D".explode()
		$"../../Area2D2".explode()
