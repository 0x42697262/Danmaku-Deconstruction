extends HBoxContainer

signal server_join(ip)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_join_pressed():
	server_join.emit($server_ip.text)
#	set_process(false)
	pass # Replace with function body.
