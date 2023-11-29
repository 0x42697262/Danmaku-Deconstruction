extends Node2D


func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	SceneSwitcher.switch('lobby_list')
