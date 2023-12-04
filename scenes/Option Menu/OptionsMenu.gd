class_name Options_Menu
extends Control

@onready var ExitOption = $MarginContainer/MarginContainer/ExitOption as Button

signal exit_options_menu

func ready():
	pass
	



func _on_exit_option_button_down():
	exit_options_menu.emit()
	pass # Replace with function body.
