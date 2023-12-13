extends Control

func _on_return_button_down():
	AudioManager.stop()
	SceneManager.switch_to_main_menu()
	multiplayer.multiplayer_peer = null
	get_node("/root/Gameplay").queue_free()
