## Lobby system
##
## Handles multiplayer connection when hosting or joining a lobby.
##
## Players are handled through groups called "players"

extends Node

var PLAYER_SCENE: PackedScene = preload("res://scenes/entities/player.tscn")
var players: Dictionary = {}

func _ready():
	print('loading: lobby system')
	for i in range(8):
		create_player(i)
	
## Instantiates a new player with an ID
func create_player(id: int):
	var player: Node = PLAYER_SCENE.instantiate()
	player.id = str(id)
	players[id] = player
	
