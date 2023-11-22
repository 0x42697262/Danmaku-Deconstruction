extends Control

signal found_server
signal server_remove

var broadcastTimer : Timer

var RoomInfo = {"name":"name", "playerCount": 0}
var broadcaster : PacketPeerUDP

# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	
func setUpBroadCast(name, playerCount):
	RoomInfo.name = name
	RoomInf0.playerCount = GameManager.Players.size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_broadcast_timer_timeout():
	pass # Replace with function body.
