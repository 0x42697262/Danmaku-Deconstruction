extends Control

var gameplay : PackedScene
signal exit

func _on_spectate_button_down():
	self.hide()

func _on_exit_button_down():
	SceneManager.switch_to_main_menu()
	multiplayer.multiplayer_peer = null
	AudioManager.stop()
	get_node("/root/Gameplay").queue_free()
