extends VBoxContainer

@export var server_info: PackedScene
@export var Address = "0.0.0.0"
@export var port = 42069

var server_instance
var peer

signal join_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_down():
#	server_instance = server_info.instantiate()
##	var new_instance = server_info.instantiate()
#	server_instance.position.x = 1000
#
#
##	var james = new_instance.get_node_and_resource("server_label2/server_name:text")
##	var james = new_instance.get_node("server_name").text
##	print(new_instance.get_node("server_name").text)
#	var RoomInfo = $"../../..".RoomInfo
#	server_instance.get_node("server_name").text = RoomInfo.server_name
#	server_instance.get_node("server_ip").text = RoomInfo.server_address
#	server_instance.server_info_join.connect(_server_join)
##	print(get_parent().get_parent().RoomInfo.server_name)
#	add_child(server_instance)
	pass # Replace with function body.

func on_server_join_button_down():
#	var server_instance = server_info.instantiate()
#	server_instance._on_join_pressed.connect(server_join)
	print("Pressed Join")
	pass
	
func _server_join():
	print("successfully joined server")
#	join_pressed.emit()
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass
