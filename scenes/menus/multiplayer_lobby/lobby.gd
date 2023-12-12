extends Control

var broadcaster     : PacketPeerUDP
var listener        : PacketPeerUDP
var room_info       : Dictionary = {"name":"name","ip_addresses":[],"player_count": 1, "players": [], 'map': ""}
var server_info     : PackedScene
@export var map     : Array
@export var songs_list : Array


var song_list_index : int
var song_path       : String

@export var address             = NetworkManager.get_ipv4_address() as String
@export var port                = NetworkManager.PORT
@export var broadcast_address   = NetworkManager.broadcast_address() as String
@export var listen_port         = NetworkManager.LISTEN_PORT
@export var broadcast_port      = NetworkManager.BROADCAST_PORT

func _ready():
	GameManager.connection_failed.connect(self._on_connection_failed)
	GameManager.connection_succeeded.connect(self._on_connection_success)
	GameManager.player_list_changed.connect(self.refresh_lobby)
	GameManager.game_ended.connect(self._on_game_ended)
	GameManager.game_error.connect(self._on_game_error)

	listener = PacketPeerUDP.new()
	var listener_ok = listener.bind(listen_port)
	$IPAddress.text = NetworkManager.get_ipv4_address()
	
	if listener_ok != OK:
		Logger.console(3, ["Failed to bind listener port (error)"])
		$Room/Broadcast.button_pressed = false
	
	songs_list = BeatmapManager.read_songs_directory()
	$Room/SongsList.clear()
	for song in songs_list:
		$Room/SongsList.add_item(song)
	$Room/BroadcastAddress.text = broadcast_address

func _on_host_pressed():
	$choice.hide()
	$Room.show()
	$Room/Broadcast.show()
	$Room/Start.show()
	$Room/Text.show()
	$Room/BroadcastAddress.show()
	$Room/Broadcasting.show()
	
	song_path = $Room/SongsList.get_item_text(0)
	_on_play_song_timeout()

	GameManager.host_game($choice/Nickname.text)
	
	

func _on_join_pressed():
	$choice.hide()
	$Server.show()
	$LobbyScanner.start()
	$Server/IPAddress.text = NetworkManager.get_ipv4_address()
	server_info = preload("res://scenes/menus/multiplayer_lobby/server.tscn")

func _on_choice_back_pressed():
	SceneManager.switch_to_main_menu()

func _on_room_back_pressed():
	$choice.show()
	$Room.hide()
	stop_broadcasting()
	GameManager.end_game()

func _on_server_back_pressed():
	$Server.hide()
	$choice.show()
	
func _on_connection_success():
	$Room.show()
	$Server.hide()
	$Room/Broadcast.hide()
	$Room/Start.hide()
	$Room/Text.hide()
	$Room/BroadcastAddress.hide()
	$Room/Broadcasting.hide()
	
func _on_connection_failed():
	$Server/IPAddress.text = "connection failed"

func _on_game_ended():
	SceneManager.switch_to_main_menu()
	AudioManager.stop()
	

func _on_game_error(error_message):
	SceneManager.switch_to_main_menu()
	Logger.console(3, ["[Multiplayer Lobby] Error:", error_message])

func refresh_lobby():
	var players = GameManager.get_player_list()
	$Room/Players/Panel/Players.clear()
	$Room/Players/Panel/Players.add_item(GameManager.get_player_name() + " (You)")
	for p in players:
		$Room/Players/Panel/Players.add_item(p.name)
	if multiplayer.is_server():
		set_current_song.rpc()

func _on_start_pressed():
	GameManager.begin_game()


func _on_server_join_pressed(ip = $Server/IPAddress.text):
	GameManager.join_game(ip, $choice/Nickname.text)


# ---- Broadcast related functions ---- #

func _on_check_button_toggled(togged_on):
	if $Room/Broadcast.button_pressed:
		start_broadcasting()
	else:
		stop_broadcasting()

func _on_broadcaster_timeout():
	room_info.player_count = GameManager.get_player_count() + 1
	var data    = JSON.stringify(room_info)
	var packet  = data.to_ascii_buffer()
	broadcaster.put_packet(packet)

func _on_broadcast_address_text_changed(new_text):
	if new_text.is_valid_ip_address():
		broadcast_address = new_text

func start_broadcasting():
	Logger.console(3, ["Bound to Listener Port", listen_port, "Successful"])
	
	room_info.name          = GameManager.player_name + "'s Server"
	room_info.player_count  = GameManager.get_player_count()
	room_info.ip_addresses  = IP.get_local_addresses()
	room_info.players       = GameManager.get_player_list()
	room_info.map           = ProjectSettings.localize_path(map[0])
	var self_info = {
		'name': GameManager.get_player_name(),
	}
	room_info.players.append(self_info)
	
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
	if listener:
		listener.close()
	
	$Room/Broadcaster.stop()
	if broadcaster != null and broadcaster.is_bound():
		broadcaster.close()
		$Room/Broadcasting.text = ""
		
		Logger.console(3, ["Stopped broadcasting server"])


func _on_ip_address_text_changed(new_text):
	new_text = new_text.strip_edges()
	if new_text.is_valid_ip_address():
		$Server/ServerJoin.disabled = false
	else:
		$Server/ServerJoin.disabled = true


func _on_server_input_text_changed(new_text):
	GameManager.set_player_name(new_text)



@rpc("authority", "call_local")
func set_current_song():
	$MultiplayerSynchronizer/PlaySong.start()
	
func _on_songs_list_item_selected(index):
	if multiplayer.is_server():
		song_list_index = index
		var path = $Room/SongsList.get_item_text(song_list_index)
		song_path = path
		set_current_song.rpc()


func _on_play_song_timeout():
	map = BeatmapManager.read_song(song_path)
	GameManager.set_map(map)
	$Room/SongsList.select(song_list_index)	


func _on_lobby_scanner_timeout():
	$IPAddress.text = NetworkManager.get_ipv4_address()
	if listener.get_available_packet_count() > 0:
		var server_ip   = listener.get_packet_ip()
		var bytes       = listener.get_packet()
		var data        = bytes.get_string_from_ascii()
		var info        = JSON.parse_string(data)

		var server_list = $Server/ServerBrowser/Panel/ServerList

		var new_server = server_info.instantiate()
		new_server.name         = server_ip
		new_server.server_name  = info.name
		new_server.player_count = str(info.player_count)
		new_server.server_ip    = server_ip

		var servers = GroupsManager.get_group('servers')
		var ip_addresses = []
		for server in servers:
			ip_addresses.append(server.name)
		if new_server.name not in ip_addresses:
			if new_server.name in ["Server", ""]:
				return
			server_list.add_child(new_server)
			new_server.joined.connect(_on_server_join_pressed)
			Logger.console(1, ["Added a new server to the list:", server_ip])
		Logger.console(0, ["Scanning for IP Addresses..."])


func _on_lobby_ip_cleaner_timeout():
	GroupsManager.call_group('servers', 'queue_free')
