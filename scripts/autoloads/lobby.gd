## Lobby system
##
## Handles multiplayer connection when hosting or joining a lobby.
##
## Players are handled through groups called "players"

extends Node

var PLAYER_SCENE: PackedScene = preload("res://scenes/entities/player.tscn")
var players: Array = []

func _ready():
	print('loading: lobby system')
	for i in range(3):
		create_player()
	

func create_player():
	var player = PLAYER_SCENE.instantiate()
	players.append(player)
	
