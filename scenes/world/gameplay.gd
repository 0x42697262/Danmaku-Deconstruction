extends Control

## Game mode selected by the host
@export var game_mode_selected: String = "musical_mode"

func _ready():
	var children = get_children()
	
	# DON'T CHANGE THIS PART
	Logger.console(3, ["Match started!"])
	Logger.console(0, [self ,"connecting signals for each players..."])
	for child in children:
		if child.has_signal("gameover"):
			child.gameover.connect(_on_gameover_signal)
	Logger.console(0, [self, "connecting signals for each players... done!"])
	
	match GameManager.get_game_mode():
		"musical":
			start_musical_mode()
		"endless":
			start_endless_mode()

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
