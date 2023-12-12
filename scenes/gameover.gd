extends Control

var gameplay : PackedScene
signal exit

func _on_spectate_button_down():
	self.hide()
	pass # Replace with function body.


func _on_exit_button_down():
	var scene = load("res://scenes/Landing Page/Landing_page.tscn").instantiate()
	get_tree().root.add_child(scene)
	#$gameover_sfx.play()
	pass # Replace with function body.
