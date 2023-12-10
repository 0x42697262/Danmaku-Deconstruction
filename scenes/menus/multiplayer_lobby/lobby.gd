extends Control

func _ready():
	$ip_address.text = NetworkManager.address()

func _on_host_pressed():
	SceneManager.switch_to_multiplayer_lobby()

func _on_join_pressed():
	SceneManager.switch_to_main_menu()
