extends Control

@export var Address = NetworkManager.get_ipv4_address()
@export var port    = NetworkManager.PORT
@export var join_button : PackedScene
 
var peer
var player_status


var RoomInfo = {
	"server_name": "server_name",
	"server_address": Address,
	}

func _ready():
	Logger.console(3, ["Started Multiplayer Session"])
	Logger.console(0, ["connecting signals..."])
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	$server_browser.server_joined.connect(join_game)
	$ip_address.text = NetworkManager.address()

	if "--server" in OS.get_cmdline_args():
		host_game()
	
	Logger.console(0, ["connecting signals... done!"])
	
func _on_join_button_pressed():
	print("Join Button Pressed")

func peer_connected(id):
	Logger.console(2, ["Player", id, "has connected."])
	
func peer_disconnected(id):
	Logger.console(2, ["Player", id, "has disconnected."])
	GameManager.unregister_player(id)
	
func connected_to_server():
	var player_id = multiplayer.get_unique_id()
	send_player_information.rpc_id(1,$server_input.text, player_id)
	
	Logger.console(2, ["Sending player information: ", player_id])
	
	
func connection_failed():
	Logger.console(2, ["Connection Failed (error)"])
	
@rpc("any_peer")
func send_player_information(player_name, id):
	GameManager.register_player(player_name, id)
	print(GameManager.players)
		
	if multiplayer.is_server():
		Logger.console(3, ["Server updating clients..."])
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)
#			Logger.console(2, ["Updating player", GameManager.Players[i].id])
#		Logger.console(3, ["Server updating clients... done!"])
		
#	print("\n", GameManager.Players)

@rpc("any_peer","call_local")
func start_game():
	Logger.console(3, ["Loading match scene..."])
	var scene = load("res://scenes/world/gameplay.tscn").instantiate()
	Logger.console(3, ["Loading match scene... done!"])
	Logger.console(3, ["Match will start..."])
	get_tree().root.add_child(scene)
	self.hide()


func _on_host_button_down():
	host_game()
	
	send_player_information($server_input.text, multiplayer.get_unique_id())

	RoomInfo.server_name = get_node("server_input").text
	player_status = "Host"
	

func join_game(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	

func host_game():
	peer = ENetMultiplayerPeer.new()
	$server_browser.setup_broadcast($server_input.text + "'s server")
	var error = peer.create_server(port, 8)
	if error != OK:
		Logger.console(3, ["Cannot Host:", error])
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	Logger.console(2, ["Waiting for players..."])
	pass

func _on_start_button_down():
	Logger.console(3, ["Start game pressed. Executing RPC()..."])
	start_game.rpc()

