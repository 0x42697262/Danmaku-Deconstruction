extends Control

signal found_server
signal server_removed

var broadcast_timer : Timer

var room_info = {"name":"name","ip":"server_ip","player_count":0}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP
var temp = ""
var peer

@export var address             = Settings.ADDRESS
@export var port                = Settings.PORT
@export var broadcast_address   = "172.16.15.255"
@export var listen_port         = Settings.LISTEN_PORT
@export var broadcast_port      = Settings.BROADCAST_PORT

@export var server_info : PackedScene

func _ready():
	broadcast_timer = $broadcast_timer
	set_up()
	
func set_up():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listen_port)
	
	if ok == OK:
		print("Bound to Listener Port " + str(listen_port) + " Successful")
		$Label2.text = "Bound to listener port: True"
	else:
		print("Failed to bind")
		$Label2.text = "Bound to listener port: False"
	
func setup_broadcast(name):
	room_info.name = name
	room_info.player_count = game_manager.Players.size()
	room_info.ip = listener.get_packet_ip()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcast_address, listen_port)
	
	var ok = broadcaster.bind(broadcast_port)
	
	if ok == OK:
		print("Bound to Broadcast Port " + str(broadcast_port) + " Successful")
	else:
		print("Failed to bind")
		
	$broadcast_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if listener.get_available_packet_count() > 0:
		var server_ip = listener.get_packet_ip()
		var server_port = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var room_info = JSON.parse_string(data)
		
		print("server ip: " + server_ip + " server_port " + str(server_port) + " roomInfo" + str(room_info))
		
#		var child = $Panel/server_list.find_child(room_info.name)
		if room_info.name != temp:
			var child = $Panel/server_list.find_child(room_info.name)
			if child != null:
				child.get_node("player_number").text = str(room_info.player_count)
			else:
				var server_instance = server_info.instantiate()
				server_instance.get_node("server_name").text = room_info.name
				server_instance.get_node("server_ip").text = listener.get_packet_ip()
				server_instance.get_node("player_count").text = str(room_info.player_count)
				$Panel/server_list.add_child(server_instance)
				server_instance.server_join.connect(join_game)
			temp = room_info.name
		else:
			return
			

func join_game(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
		
		
func _join_button_pressed():
#	peer = ENetMultiplayerPeer.new()
#	peer.create_client(address, 8000)
#	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
#	multiplayer.set_multiplayer_peer(peer)
	print("pressed")
			

func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	room_info.player_count = game_manager.Players.size()
	var data = JSON.stringify(room_info)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
#	$broadcast_timer.stop()
	pass # Replace with function body.

func clean_up():
	listener.close()
	
	$broadcast_timer.stop()
	if broadcaster != null:
		broadcaster.close()

func _exit_tree():
	clean_up()
