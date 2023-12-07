extends Control


func _ready():
	# James, change thiss part sa spawning.
	var index = 0
	
	for i in game_manager.Players:
		var player = preload("res://scenes/entities/player.tscn").instantiate()
		var area = size
		add_child(player)
		player.global_position = Vector2(209,156)
		
	var children = get_children()
	
	# DON'T CHANGE THIS PART
	Logger.console(3, ["Match started!"])
	Logger.console(0, [self ,"connecting signals for each players..."])
	for child in children:
		if child.has_signal("gameover"):
			child.gameover.connect(_on_gameover_signal)
	Logger.console(0, [self, "connecting signals for each players... done!"])

func _on_gameover_signal(player):
	player.queue_free()
