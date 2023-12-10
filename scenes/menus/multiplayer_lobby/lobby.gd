extends Control

var broadcaster     : PacketPeerUDP
var listener        : PacketPeerUDP
var room_info       : Dictionary = {"name":"name","ip":"server_ip","player_count": 0}


@export var address             = NetworkManager.get_ipv4_address()
@export var port                = NetworkManager.PORT
@export var broadcast_address   = "172.16.15.255"
@export var listen_port         = NetworkManager.LISTEN_PORT
@export var broadcast_port      = NetworkManager.BROADCAST_PORT

func _ready():
		$ip_address.text = NetworkManager.get_ipv4_address()
		GameManager.connection_failed.connect(self._on_connection_failed)
		GameManager.connection_succeeded.connect(self._on_connection_success)
		GameManager.player_list_changed.connect(self.refresh_lobby)
		GameManager.game_ended.connect(self._on_game_ended)
		GameManager.game_error.connect(self._on_game_error)

func _on_host_pressed():
	$choice.hide()
	$Room.show()

func _on_join_pressed():
	pass

func _on_choice_back_pressed():
	SceneManager.switch_to_main_menu()

func _on_room_back_pressed():
	$choice.show()
	$Room.hide()
	stop_broadcasting()

func _on_connection_success():
	pass

func _on_connection_failed():
	pass

func _on_game_ended():
	pass

func _on_game_error(errtxt):
	pass

func refresh_lobby():
	pass

func _on_start_pressed():
	pass # Replace with function body.


# ---- Broadcast related functions ---- #

func _on_check_button_toggled(toggled_on):
	if $Room/Broadcast.button_pressed:
		start_broadcasting()
	else:
		stop_broadcasting()

func _on_broadcaster_timeout():
	room_info.player_count = GameManager.get_player_count()
	var data    = JSON.stringify(room_info)
	var packet  = data.to_ascii_buffer()
	broadcaster.put_packet(packet)

func _on_broadcast_address_text_changed(new_text):
	broadcast_address = new_text

func start_broadcasting():
	listener = PacketPeerUDP.new()
	var listener_ok = listener.bind(listen_port)
	$Room/BroadcastAddress.editable = true
	broadcast_address = $Room/BroadcastAddress.text
	
	if listener_ok != OK:
		Logger.console(3, ["Failed to bind listener port (error)"])
		$Room/Broadcast.button_pressed = false
		
		return
	Logger.console(3, ["Bound to Listener Port", listen_port, "Successful"])
	
	room_info.name          = name
	room_info.player_count  = GameManager.get_player_count()
	room_info.ip            = listener.get_packet_ip()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcast_address, listen_port)
	
	var broadcaster_ok = broadcaster.bind(broadcast_port)
	
	if broadcaster_ok != OK:
		Logger.console(3, ["Failed to bind broadcast port (error)"])
		$Room/Broadcast.button_pressed = false
		
		return
	Logger.console(3, ["Bound to Broadcast Port", broadcast_port, "Successful"])
	
	$Room/Broadcaster.start()
	$Room/Broadcasting.text = "Broadcasting..."
	
	Logger.console(3, ["Started Broadcast Timer on", broadcast_address])

func stop_broadcasting():
	$Room/Broadcast.button_pressed = false
	$Room/BroadcastAddress.editable = false
	listener.close()
	
	$Room/Broadcaster.stop()
	if broadcaster != null and broadcaster.is_bound():
		broadcaster.close()
		$Room/Broadcasting.text = ""
		
		Logger.console(3, ["Stopped broadcasting server"])
