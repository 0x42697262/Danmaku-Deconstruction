extends Control

var gameplay : PackedScene
signal exit

func exit_game():
		AudioManager.stop()
		multiplayer.multiplayer_peer = null
		GameManager.hide_mouse(false)
		if has_node("/root/Gameplay"):
			get_node("/root/Gameplay").queue_free()
		SceneManager.switch_to_main_menu()

func _on_spectate_button_down():
	self.hide()

func _on_exit_button_down():
	# The host may only leave once the match is over (no players remain),
	# otherwise leaving would tear the game down for everyone still playing.
	# Non-host players can always leave.
	if not GroupsManager.get_group('players') or not multiplayer.is_server():
		exit_game()
