extends Control


func _ready():
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
	
	var endless_mode = preload("res://scenes/world/endless_mode.tscn").instantiate()
	add_child(endless_mode)
	endless_mode.spawn.connect(_on_spawn_a_star)
	Logger.console(3, ["Configured Beatmap Manager type to endless mode"])
	
	var p = preload("res://scenes/entities/player.tscn")
	add_child(p.instantiate())
	
func _on_spawn_a_star(star):
	add_child(star)
	
func _on_gameover_signal(player):
	player.queue_free()
