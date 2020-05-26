extends TextureButton
var a

func _on_Button_pressed():
	a = get_tree().change_scene("res://scenes/Menus/MainMenu/Menu.tscn")
