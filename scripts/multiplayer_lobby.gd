extends Control

@export var Address = "0.0.0.0"
@export var port = 42069
var peer
var player_status

#signal join_pressed

@export var join_button : PackedScene

var RoomInfo = {"server_name":"server_name","server_address":Address}

#@export var server: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
#	var join = get_node("/root/scenes/server_info.tscn/Join")
#	if join:
#		join.connect("pressed", self, "_on_button_pressed")

	pass # Replace with function body.
	

func _on_join_button_pressed():
	print("Join Button Pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	
#	var new_instance = server.instantiate()
#	new_instance.position.x = 1000
#	add_child(new_instance)
	
	RoomInfo.server_name = get_node("server_input").text
#	print("Submitted")
	
	player_status = "Host"
	
	
	pass # Replace with function body.



func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.

func _on_start_button_down():
	start_game.rpc()
	pass # Replace with function body.
