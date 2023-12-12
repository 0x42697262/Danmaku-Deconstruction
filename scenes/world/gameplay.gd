extends Control

@export var map = GameManager.get_map() as Array
@export var is_playing = false as bool

var hitcircle = preload("res://scenes/entities/spawner/hitcircle.tscn")

func _ready():
	AudioManager.stop()
	AudioManager.finished.connect(_on_finished)

	create_notes()
	$Countdown.start()
	$ExitDialog.hide()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$ExitDialog.show()

func create_notes():
	var notes = map[1]
	for data in notes:
		var note = hitcircle.instantiate()
		add_child(note)
		note.spawned.connect(_on_player_died)

		var x_y = _scale_coordinates(int(data['x']), int(data['y']))
		var time = (float(data['time']) / 1000) - (2 + $Countdown.time_left)
		var type = int(data['type'])
		note.create_a_note(x_y, time, type)
		
func _on_spawned(note):
	add_child(note)
	
func _on_player_died(explosion):
	add_child(explosion)
	var len_players = len($Players.get_children())
	#if len_players == 0:
		#AudioManager.stop()


func _on_gameover():
	$Gameover.show()

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

func _on_countdown_timeout():
	var players = GroupsManager.get_group('players')
	for player in players:
		player.died.connect(_on_spawned)
		player.gameover.connect(_on_gameover)
		player.health_changed.connect(_on_player_health_changed)
	if !map:
		GameManager.game_error.emit("No beatmap selected.")
		return
	if len(map) < 2:
		GameManager.game_error.emit("Missing beatmap properties")
		return

	var audio = map[0]
	var notes = GroupsManager.get_group("notes")
	AudioManager.play(audio)
	is_playing = true
	for note in notes:
		note.start()

func _on_finished():
	print('win')

func _on_player_health_changed(current_hp):
	$HP.text = str(clamp(current_hp,0,1000))
	print(current_hp)

func _on_gameover_signal():
	var scene = load("res://scenes/world/gameover.tscn").instantiate()

func _on_yes_button_down():
	AudioManager.stop()
	SceneManager.switch_to_main_menu()
	multiplayer.multiplayer_peer = null
	get_node("/root/Gameplay").queue_free()
	
func _on_check_players_timeout():
	if not GroupsManager.get_group('players'):
		GameManager.end_game()
