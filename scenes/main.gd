## Main Node
##
## For changing scenes, please see scripts/managers/scene_manager.gd

extends Node2D

func _ready():
	if "--debug" in OS.get_cmdline_args():
		GameManager.debug = true
		Logger.console(4, ['Debug mode has been enabled.'])
	SceneManager.switch_to_main_menu()
