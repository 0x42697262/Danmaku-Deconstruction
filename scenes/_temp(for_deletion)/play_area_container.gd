extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var lobby = get_node("/root/Lobby")
	var players = lobby.players
	var i = 0
	for player in players:
		add_child(player)
		player.position = Vector2(randi_range(30,770), 598)
		i+=1
	print('succesfully added players: ', i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
