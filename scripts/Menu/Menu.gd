extends Node2D

var a

func _ready():
	pass

func _process(_delta):
	$"ColorRect/Title".percent_visible += 0.01

func _on_ControlsButton_pressed():
	a = get_tree().change_scene("res://scenes/Menus/MainMenu/Submenus/Controls/Controls.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
