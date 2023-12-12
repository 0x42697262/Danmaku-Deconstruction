extends Control

var gameplay : PackedScene
signal exit

func exit_game():
		AudioManager.stop()
		SceneManager.switch_to_main_menu()
		multiplayer.multiplayer_peer = null
		get_node("/root/Gameplay").queue_free()

func _on_spectate_button_down():
	self.hide()

func _on_exit_button_down():
	if not GroupsManager.get_group('players'):
		exit_game()

	if not multiplayer.is_server():
		exit_game()
