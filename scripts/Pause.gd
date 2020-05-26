extends Control


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		self.visible = not self.visible
		get_tree().paused = not get_tree().paused


func _on_Continue_pressed():
	self.visible = not self.visible
	get_tree().paused = not get_tree().paused

func _on_Quit_Game_pressed():
	get_tree().quit()


func _on_To_Menu_pressed():
	get_tree().paused = not get_tree().paused
	print(get_tree().change_scene("res://Scenes/Menu/Menu.tscn"))
