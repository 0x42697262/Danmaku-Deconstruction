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
	GameLogger.console(4, ["Scene Manager Ready."])

func switch_to_main_menu():
	var scene = preload("res://scenes/menus/main_menu/main_menu.tscn") as PackedScene
	__switch(scene)
	
func switch_to_multiplayer_lobby():
	var scene = preload("res://scenes/menus/multiplayer_lobby/lobby.tscn") as PackedScene
	__switch(scene)

func __switch(scene: PackedScene):
	# Deferred so it is safe to switch scenes from within a node's _ready()
	# (e.g. main.gd swaps to the main menu on boot). Calling it directly while
	# the tree is still adding the initial scene's children raises a "parent is
	# busy adding/removing children" error in Godot 4.4+.
	get_tree().change_scene_to_packed.call_deferred(scene)
	var scene_log = {
		'timestamp': Time.get_ticks_msec(),
		'scene': scene,
	}
	scene_logs.append(scene_log)
	
func get_logs() -> Array[Dictionary]:
	return scene_logs
