extends Control

@export var map = GameManager.get_map() as Array
@export var is_playing = false as bool

var hitcircle = preload("res://scenes/entities/spawner/hitcircle.tscn")

func _ready():
	AudioManager.stop()

	create_notes()
	$Countdown.start()

	Logger.console(3, ["Match started!"])
	
func _on_countdown_timeout():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.died.connect(_on_spawned)
	if !map:
		GameManager.game_error.emit("No beatmap selected.")
		return
	if len(map) < 2:
		GameManager.game_error.emit("Missing beatmap properties")
		return

	var audio = map[0]
	var notes = get_tree().get_nodes_in_group("notes")
	AudioManager.play(audio)
	is_playing = true
	for note in notes:
		note.start()

func create_notes():
	var notes = map[1]
	for data in notes:
		var note = hitcircle.instantiate()
		add_child(note)
		note.spawned.connect(_on_spawned)

		var x_y = _scale_coordinates(int(data['x']), int(data['y']))
		var time = (float(data['time']) / 1000) - (2 + $Countdown.time_left)
		var type = int(data['type'])
		note.create_a_note(x_y, time, type)
		
func _on_spawned(note):
	add_child(note)

func _scale_coordinates(original_x: float, original_y: float) -> Vector2:
		var original_min_x = 0.0
		var original_max_x = 512.0
		var target_min_x = 0.0
		var target_max_x = 1152.0
		
		var original_min_y = 0.0
		var original_max_y = 384.0
		var target_min_y = 0.0
		var target_max_y = 648.0
		
		var scaled_x = lerp(target_min_x, target_max_x, inverse_lerp(original_min_x, original_max_x, original_x))
		var scaled_y = lerp(target_min_y, target_max_y, inverse_lerp(original_min_y, original_max_y, original_y))
		
		return Vector2(scaled_x, scaled_y)


