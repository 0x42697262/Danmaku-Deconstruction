extends Control

@export var Address = Settings.ADDRESS
@export var port    = Settings.PORT
var peer
var player_status

#signal join_pressed

@export var join_button : PackedScene

var RoomInfo = {
	"server_name": "server_name",
	"server_address": Address,
	}

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
func _on_join_button_pressed():
	print("Join Button Pressed")

func peer_connected(id):
	print("Player Connected " + str(id))
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	
func connected_to_server():
	print("Connected to server")
	send_player_information.rpc_id(1, multiplayer.get_unique_id())
	
func connection_failed():
	print("Connection Failed")
	
@rpc("any_peer")
func send_player_information(name, id):
	if !game_manager.Players.has(id):
		game_manager.Players[id]={
			"name": name,
			"id": id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in game_manager.Players:
			send_player_information.rpc(game_manager.Players[i].name, i)

@rpc("any_peer","call_local")
func start_game():
	var scene = load("res://scenes/world/gameplay.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	$server_browser.setup_broadcast($server_input.text + "'s server")
	var error = peer.create_server(port, 8)
	if error != OK:
		print("Cannot Host: " + str(error))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players!")
	
	send_player_information($server_input.text, multiplayer.get_unique_id())

	RoomInfo.server_name = get_node("server_input").text
	player_status = "Host"
	


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_button_down():
	start_game.rpc()
