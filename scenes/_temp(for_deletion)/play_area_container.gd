extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = preload("res://scenes/world/player.tscn").instantiate()
	add_child(player)
	player.position = Vector2(0,632)
	print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
