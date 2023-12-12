extends Control

@onready var clickButton = $clickButton as AudioStreamPlayer
var gameplay : PackedScene
signal exit

func _on_spectate_button_down():
	clickButton.play()
	self.hide()

func _on_exit_button_down():
	clickButton.play()
	SceneManager.switch_to_main_menu()
	multiplayer.multiplayer_peer = null
