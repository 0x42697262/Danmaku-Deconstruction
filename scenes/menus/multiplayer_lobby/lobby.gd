extends Control

var broadcaster     : PacketPeerUDP
var listener        : PacketPeerUDP
var room_info       : Dictionary = {"name":"name","ip":"server_ip","player_count": 1, "players": []}
@export var map     : Array
@export var songs_list : Array

var song_list_index : int
var song_path       : String

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
	
	songs_list = BeatmapManager.read_songs_directory()
	$Room/SongsList.clear()
	for song in songs_list:
		$Room/SongsList.add_item(song)	

func _on_host_pressed():
	$choice.hide()
	$Room.show()
	$Room/Broadcast.show()
	$Room/Start.show()
	$Room/Text.show()
	$Room/BroadcastAddress.show()
	$Room/Broadcasting.show()
	$Room/IsMusical.disabled = false
	

	GameManager.host_game($choice/Nickname.text)
	
	

func _on_join_pressed():
	$choice.hide()
	$Server.show()
	$Room/IsMusical.disabled = true

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
	pass

func _on_game_error(error_message):
	Logger.console(3, ["[Multiplayer Lobby] Error:", error_message])

func refresh_lobby():
	var players = GameManager.get_player_list()
	$Room/Players/Panel/Players.clear()
	$Room/Players/Panel/Players.add_item(GameManager.get_player_name() + " (You)")
	for p in players:
		$Room/Players/Panel/Players.add_item(p.name)

func _on_start_pressed():
	GameManager.begin_game()


func _on_server_join_pressed():
	var ip = $Server/IPAddress.text
	GameManager.join_game(ip, $choice/Nickname.text)


# ---- Broadcast related functions ---- #

func _on_check_button_toggled(toggled_on):
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
	room_info.players       = GameManager.get_player_list()
	var self_info = {
		'name': GameManager.get_player_name(),
		'score': GameManager.get_score(),
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
	$Room/BroadcastAddress.editable = false
	if listener:
		listener.close()
	
	$Room/Broadcaster.stop()
	if broadcaster != null and broadcaster.is_bound():
		broadcaster.close()
		$Room/Broadcasting.text = ""
		
		Logger.console(3, ["Stopped broadcasting server"])


func _on_ip_address_text_changed(new_text):
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


# --- CODE THAT IS USELESS --- #
@rpc("any_peer", "call_local", "reliable")
func set_game_mode():
	if $Room/IsMusical.button_pressed:
		GameManager.set_game_mode(0)
	else:
		GameManager.set_game_mode(1)
		
func _on_is_musical_pressed():
	set_game_mode.rpc()


# --- CODE THAT IS USELESS --- #





func _on_timer_timeout():
	$Room/SongsList.select(song_list_index)
	$SHIT.text = song_path
	


func _on_play_song_timeout():
	BeatmapManager.read_song(song_path)
