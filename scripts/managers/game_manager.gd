extends Node

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(reason)

const PORT      = NetworkManager.PORT
const MAX_PEERS = NetworkManager.MAX_PEERS

var peer        = null

var player_name = "DaChicken"

var players = {}


func _ready():
		multiplayer.peer_connected.connect(self._player_connected)
		multiplayer.peer_disconnected.connect(self._player_disconnected)
		multiplayer.connected_to_server.connect(self._connected_ok)
		multiplayer.connection_failed.connect(self._connected_fail)
		multiplayer.server_disconnected.connect(self._server_disconnected)

# ---- Property related functions ---- #

func get_player_list():
		return players.values()

func get_player_count() -> int:
	return players.size()

func get_player_name():
		return player_name

@rpc("any_peer")
func register_player(new_player_name: String):
		var player_id = multiplayer.get_remote_sender_id()
		players[player_id] = {
			'name'  : new_player_name,
			'hp'    : 30,
			'score' : 0,
			}
		player_list_changed.emit()

		Logger.console(3, ["[Game Manager] Registered player:", player_name, player_id])

func unregister_player(player_id: int):
	if players.has(player_id):
		Logger.console(3, ["[Game Manager] Unregistered player:", players['name'], player_id])

		players.erase(player_id)
		player_list_changed.emit()

# ---- Game match related functions ---- #

func end_game():
		if has_node("/root/gameplay"):
			get_node("/root/gameplay").queue_free()

		game_ended.emit()
		players.clear()
		
		Logger.console(3, ["[Game Manager] Game has ended."])

func host_game(new_player_name):
	player_name   = new_player_name
	peer          = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PEERS)
	multiplayer.set_multiplayer_peer(peer)

	Logger.console(3, ["[Game Manager] Hosted game on", NetworkManager.get_ipv4_address()])

func join_game(ip, new_player_name):
	player_name   = new_player_name
	peer          = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.set_multiplayer_peer(peer)

	Logger.console(3, ["[Game Manager]", ip, "has joined the game."])

# ---- Multiplayer related functions ---- #

func _player_connected(id):
		Logger.console(3, ["[Game Manager] Player", id, "disconnecting..." ])
		register_player.rpc_id(id, player_name)

func _player_disconnected(id):
		if has_node("/root/gameplay"):
				if multiplayer.is_server():
						game_error.emit("Player" + players[id] + " disconnected")
						end_game()
		else:
			unregister_player(id)

func _connected_ok():
		connection_succeeded.emit()

func _connected_fail():
		multiplayer.set_network_peer(null)
		connection_failed.emit()

func _server_disconnected():
		game_error.emit("Server disconnected")
		end_game()
