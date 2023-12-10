extends Node

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(reason)

var players = {}

func register_player(player_name: String, player_id: int):
	if !players.has(player_id):
		players[player_id] = {
			'name'  : player_name,
			'hp'    : 30,
			'score' : 0,
		  }
		Logger.console(3, ["[Game Manager] Added new player to the list:", player_name, player_id])

func unregister_player(player_id: int):
	if players.has(player_id):
		players.remove(player_id)

		Logger.console(3, ["[Game Manager] Removed player:", players['name'], player_id])
