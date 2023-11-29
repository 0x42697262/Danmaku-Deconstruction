extends VBoxContainer

@export var server_info: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_down():
	var new_instance = server_info.instantiate()
	new_instance.position.x = 1000
	
	
#	var james = new_instance.get_node_and_resource("server_label2/server_name:text")
#	var james = new_instance.get_node("server_name").text
#	print(new_instance.get_node("server_name").text)
	var RoomInfo = get_parent().get_parent().RoomInfo
	new_instance.get_node("server_name").text = RoomInfo.server_name
	new_instance.get_node("server_ip").text = RoomInfo.server_address
#	print(get_parent().get_parent().RoomInfo.server_name)
	add_child(new_instance)
	pass # Replace with function body.
