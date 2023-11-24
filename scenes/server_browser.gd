extends Control

signal found_server
signal server_removed

var broadcast_timer : Timer

var room_info = {"name":"name","player_count":0}
var broadcast = PacketPeerUDP

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcast_timer = $broadcast_timer
	pass # Replace with function body.
	
	
func setup_broadcast(name, count):
	room_info.name = name
	room_info.player_count = game_manager.Players.size()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_broadcast_timer_timeout():
	
	pass # Replace with function body.
