extends HBoxContainer

signal server_join(ip)

func _on_join_pressed():
	server_join.emit($server_ip.text)

