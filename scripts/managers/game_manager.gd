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
var score       = 0 as int

@export var selected_map : Array

var players = {}


func _ready():
		multiplayer.peer_connected.connect(self._player_connected)
		multiplayer.peer_disconnected.connect(self._player_disconnected)
		multiplayer.connected_to_server.connect(self._connected_ok)
		multiplayer.connection_failed.connect(self._connected_fail)
		multiplayer.server_disconnected.connect(self._server_disconnected)

# ---- Property related functions ---- #

func set_map(map: Array):
	self.selected_map = map

func get_map():
	return self.selected_map

func get_player_list():
		return players.values()

func get_score() -> int:
	return score

func get_player_count() -> int:
	return players.size()

func get_player_name():
		return player_name

func set_player_name(nickname):
	player_name = nickname
	if len(nickname) == 0:
		player_name = "DaChicken"

@rpc("any_peer")
func register_player(new_player_name: String):
		var player_id = multiplayer.get_remote_sender_id()
		players[player_id] = {
			'name'  : new_player_name,
			'score' : score,
			}
		player_list_changed.emit()

		Logger.console(3, ["[Game Manager] Registered player:", player_name, player_id])

func unregister_player(player_id: int):
	if players.has(player_id):
		Logger.console(3, ["[Game Manager] Unregistered player:", players[player_id]['name'], player_id])

		players.erase(player_id)
		player_list_changed.emit()

# ---- Game match related functions ---- #

func end_game():
		if has_node("/root/Gameplay"):
			get_node("/root/Gameplay").queue_free()

		game_ended.emit()
		players.clear()
		
		Logger.console(3, ["[Game Manager] Game has ended."])

func host_game(new_player_name):
	player_name   = new_player_name
	peer          = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PEERS)
	multiplayer.set_multiplayer_peer(peer)

	Logger.console(3, ["[Game Manager] Hosted game on", IP.get_local_addresses()[0]])

func join_game(ip, new_player_name):
	player_name   = new_player_name
	peer          = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.set_multiplayer_peer(peer)

	Logger.console(3, ["[Game Manager]", new_player_name, "(", ip, ") is trying to join the game..."])

@rpc("call_local")
func load_world():
	# Change scene.
	var world = load("res://scenes/world/gameplay.tscn").instantiate()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").hide()

	get_tree().set_pause(false)


func begin_game():
	assert(multiplayer.is_server())
	load_world.rpc()

	var world = get_tree().get_root().get_node('Gameplay')
	var player_scene = load("res://scenes/entities/player.tscn")

	# Create a dictionary with peer id and respective spawn points, could be improved by randomizing.
	var spawn_points = {}
	spawn_points[1] = 0 # Server in spawn point 0.
	var spawn_point_idx = 1
	for p in players:
		spawn_points[p] = spawn_point_idx
		spawn_point_idx += 1
		
	var _index = 1
	for player_id in spawn_points:
		var player = player_scene.instantiate()
		player.global_position              = Vector2(randi_range(500,600), randi_range(300,400))
		player.name                         = str(player_id)
		# player.get_node('sprite').texture   = TextureManager.get_planet(_index)

		world.get_node("Players").add_child(player)
		Logger.console(3, ["Spawned player", player.name])

		_index += 1

# ---- Multiplayer related functions ---- #

func _player_connected(id):
		Logger.console(3, ["[Game Manager] Player", player_name, id, "connected." ])
		register_player.rpc_id(id, player_name)

func _player_disconnected(id):
		if has_node("/root/Gameplay"):
				if multiplayer.is_server():
						game_error.emit("Player" + players[id].name + " disconnected")
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
		multiplayer.multiplayer_peer = null
