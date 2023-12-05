extends VBoxContainer

@export var server_info: PackedScene


func _on_host_button_down():
	var new_instance = server_info.instantiate()
	new_instance.position.x = 1000
	
	var RoomInfo = get_parent().get_parent().RoomInfo
	new_instance.get_node("server_name").text = RoomInfo.server_name
	new_instance.get_node("server_ip").text = RoomInfo.server_address
#	print(get_parent().get_parent().RoomInfo.server_name)
	add_child(new_instance)
