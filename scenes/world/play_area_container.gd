extends VBoxContainer


func _ready():
	add_players(LobbyManager.players)
	

## Adds new player as a child to the play area
func add_players(players):
	var spots: Array = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550,
						600, 650, 700, 750]
	spots.shuffle()
	
	var i = 0
	for player in players:
		player = players[player]
		add_child(player)
		var location = spots.pop_back()
		player.position = Vector2(location, 598)
		i+=1
	print('succesfully added players: ', i)
