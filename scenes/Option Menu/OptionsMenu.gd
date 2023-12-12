class_name Options_Menu
extends Control

@onready var ExitOption = $MarginContainer/MarginContainer/ExitOption as Button
@onready var clickButton = $clickButton as AudioStreamPlayer

signal exit_options_menu

func ready():
	pass
	



func _on_exit_option_button_down():
	clickButton.play()
	exit_options_menu.emit()
	pass # Replace with function body.
