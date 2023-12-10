## Scene Manager
##
## Used for switching scenes.
##
## To switch to a new scene, create a new function by preloading a PackedScene
## and use the function `__switch` with the PackedScene as the argument. 
##
## When switching the scene locations, it is all handled in one script and makes it easier for us
## to debug.

extends Node

var scene_logs: Array[Dictionary]

func _ready():
	Logger.console(4, ["Scene Manager Ready."])

func switch_to_main_menu():
	var scene = preload("res://scenes/menus/main_menu/main_menu.tscn") as PackedScene
	__switch(scene)
	
func switch_to_multiplayer_lobby():
	var scene = preload("res://scenes/menus/multiplayer_lobby/lobby.tscn") as PackedScene
	__switch(scene)

func __switch(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
	var scene_log = {
		'timestamp': Time.get_ticks_msec(),
		'scene': scene,
	}
	scene_logs.append(scene_log)
	
func get_logs() -> Array[Dictionary]:
	return scene_logs
