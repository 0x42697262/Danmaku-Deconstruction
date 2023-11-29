extends Node2D



func _on_host_pressed():
	SceneSwitcher.switch('room')
	print("Hosted on port ", Settings.port)
	


func _on_join_pressed():
	pass # Replace with function body.
