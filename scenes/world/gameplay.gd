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

## Game mode selected by the host
@export var game_mode_selected: String = "musical_mode"

func _ready():
	var index = 0

	for i in GameManager.players:
		var player = preload("res://scenes/entities/player.tscn").instantiate()
		var area = size
		player.name = "player" + str(GameManager.players[i].id)
		player.get_node("sprite").texture = player_texture[index+1]
		player.spawn.connect(_on_spawn_a_star)
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
	
	match game_mode_selected:
		"musical_mode":
			start_musical_mode()
		"endless_mode":
			start_endless_mode.rpc()

@rpc("authority", "call_local", "reliable")
func start_endless_mode():
	Logger.console(3, ["Selected mode is Endless Mode."])
	var mode = preload("res://scenes/world/game_modes/endless_mode.tscn").instantiate()
	add_child(mode)
	mode.spawn.connect(_on_spawn_a_star)

#@rpc("authority", "call_local", "reliable")
func start_musical_mode():
	Logger.console(3, ["Selected mode is Musical Mode."])
	var mode = preload("res://scenes/world/game_modes/musical_mode.tscn").instantiate()
	add_child(mode)
	mode.spawn.connect(_on_spawn_a_star)
	
	
func _on_spawn_a_star(star):
	add_child(star)
	
func _on_gameover_signal(player):
	player.queue_free()
