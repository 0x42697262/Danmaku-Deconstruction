extends Control

func _on_return_button_down():
	AudioManager.stop()
	multiplayer.multiplayer_peer = null
	GameManager.hide_mouse(false)
	if has_node("/root/Gameplay"):
		get_node("/root/Gameplay").queue_free()
	SceneManager.switch_to_main_menu()
