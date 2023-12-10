extends Control

var p1: Texture = preload("res://assets/Characters/mercury.png")
var p2: Texture = preload("res://assets/Characters/venus.png")
var p3: Texture = preload("res://assets/Characters/earth.png")
var p4: Texture = preload("res://assets/Characters/mars.png")
var p5: Texture = preload("res://assets/Characters/jupiter.png")
var p6: Texture = preload("res://assets/Characters/saturn.png")
var p7: Texture = preload("res://assets/Characters/uranus.png")
var p8: Texture = preload("res://assets/Characters/neptune.png")

var player_texture = [p1, p2, p3, p4, p5, p6, p7, p8]

func _ready():
	var index = 0

	for i in game_manager.Players:
		var player = preload("res://scenes/entities/player.tscn").instantiate()
		var area = size
		player.name = str(game_manager.Players[i].id)
		player.get_node("sprite").texture = player_texture[index+1]
		add_child(player)
		player.global_position = Vector2(randi_range(0,1152), randi_range(0,648))
		index += 1
	
	var children = get_children()
	
	# DON'T CHANGE THIS PART
	Logger.console(3, ["Match started!"])
	Logger.console(0, [self ,"connecting signals for each players..."])
	for child in children:
		if child.has_signal("gameover"):
			child.gameover.connect(_on_gameover_signal)
	Logger.console(0, [self, "connecting signals for each players... done!"])
	
	
	# temporary parts
	#var mode = preload("res://scenes/world/game_modes/endless_mode.tscn").instantiate()
	var mode = preload("res://scenes/world/game_modes/musical_mode.tscn").instantiate()	
	add_child(mode)
	mode.spawn.connect(_on_spawn_a_star)
	
	var p = preload("res://scenes/entities/player.tscn")
	add_child(p.instantiate())
	
func _on_spawn_a_star(star):
	add_child(star)
	
func _on_gameover_signal(player):
	player.queue_free()
