class_name TutorialsMenu
extends Control

@onready var ExitTutorial = $ExitTutorial as Button

signal exit_tutorial

func ready():
	pass
	


func _on_exit_tutorial_button_down():
	exit_tutorial.emit()
	pass # Replace with function body.
