extends Node

var list_of_scenes: Dictionary

func _ready():
	list_of_scenes["gameplay"] = preload("res://scenes/world/gameplay.tscn")
	
	# temporary
	
	list_of_scenes['main_menu'] = preload("res://scenes/_temp(for_deletion)/1_main_menu.tscn")
	list_of_scenes['lobby_list'] = preload("res://scenes/_temp(for_deletion)/2_lobby_list.tscn")
	list_of_scenes['room'] = preload("res://scenes/_temp(for_deletion)/3_room.tscn")
	list_of_scenes['multiplayer_lobby'] = preload("res://scenes/_temp(for_deletion)/multiplayer_lobby.tscn")


func switch(scene: String):
	get_tree().change_scene_to_packed(list_of_scenes[scene])
