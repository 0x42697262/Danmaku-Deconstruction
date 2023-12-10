extends Control

signal found_server
signal server_removed
signal server_joined(ip)

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
		Logger.console(3, ["Bound to Listener Port", listen_port, "Successful"])
		$Label2.text = "Bound to listener port: True"
	else:
		Logger.console(3, ["Failed to bind listener port (error)"])
		$Label2.text = "Bound to listener port: False"
	
func setup_broadcast(name):
	room_info.name = name
	room_info.player_count = GameManager.Players.size()
	room_info.ip = listener.get_packet_ip()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcast_address, listen_port)
	
	var ok = broadcaster.bind(broadcast_port)
	
	if ok == OK:
		Logger.console(3, ["Bound to Broadcast Port", broadcast_port, "Successful"])
	else:
		Logger.console(3, ["Failed to bind broadcast port (error)"])
		
	$broadcast_timer.start()
	
	Logger.console(3, ["Started Broadcast Timer to", broadcast_address])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if listener.get_available_packet_count() > 0:
		var server_ip = listener.get_packet_ip()
		var server_port = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var room_info = JSON.parse_string(data)
		
		# print("server ip: " + server_ip + " server_port: " + str(server_port) + " roomInfo: " + str(room_info))
		
#		var child = $Panel/server_list.find_child(room_info.name)
#		var child = $Panel/server_list.find_child(room_info.name)
#		for i in $Panel/server_list.get_children():
#			if i.name == room_info.name:
#				i.get_node("player_count").text = str(room_info.player_count)
#				return
#
##		if room_info.name == temp:
##			return
#
#		var server_instance = server_info.instantiate()
#		server_instance.name = room_info.name
#		server_instance.get_node("server_name").text = room_info.name
#		server_instance.get_node("server_ip").text = listener.get_packet_ip()
#		server_instance.get_node("player_count").text = str(room_info.player_count)
#		$Panel/server_list.add_child(server_instance)
#		server_instance.server_join.connect(join_game)
#		temp = room_info.name
#		pass

		if room_info.name != temp:
			var server_instance = server_info.instantiate()
			server_instance.name = room_info.name
			server_instance.get_node("server_name").text = room_info.name
			server_instance.get_node("server_ip").text = listener.get_packet_ip()
			server_instance.get_node("player_count").text = str(room_info.player_count)
			$Panel/server_list.add_child(server_instance)
			server_instance.server_join.connect(join_game)
			temp = room_info.name
		else:
			for i in $Panel/server_list.get_children():
				if i.name == room_info.name:
					i.get_node("player_count").text = str(room_info.player_count)
					return
##			server_instance.get_node("player_count").text = ""
##			if child != null:
##				child.get_node("player_count").text = str(room_info.player_count)
#			return
			
#		for i in $Panel/server_list.get_children():
#			if i.name == room_info.name:
#				i.get_node("player_count").text = str(room_info.player_count)
#				return
			

func join_game(ip):
	server_joined.emit(ip)
			

func _on_broadcast_timer_timeout():
	# print("Broadcasting Game!")
	room_info.player_count = GameManager.Players.size()
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
