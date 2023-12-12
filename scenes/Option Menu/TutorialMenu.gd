class_name TutorialsMenu
extends Control

@onready var ExitTutorial = $ExitTutorial as Button
@onready var clickButton = $clickButton as AudioStreamPlayer

signal exit_tutorial

func ready():
	pass
	


func _on_exit_tutorial_button_down():
	clickButton.play()
	exit_tutorial.emit()
	pass # Replace with function body.



func _on_tutorial_a_mouse_entered():
	clickButton.play()
	pass # Replace with function body.
