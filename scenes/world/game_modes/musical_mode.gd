extends Node2D

signal spawn(star)


@onready var spawner: PackedScene = preload("res://scenes/entities/spawner/spawner.tscn")
var maps: Array

## Time the match has started in milliseconds
@export var start_time: int
## Countdown before game starts in seconds
@export var countdown_start: int = 3
## Time elapsed in milliseconds
@export var elapsed_time: int
## Current time in milliseconds
@export var current_time: int

@export var is_currently_playing: bool = false
@export var music: AudioStreamPlayer = AudioStreamPlayer.new()
var create_note = preload("res://scenes/entities/spawner/note_spawner.tscn")

func _ready():
	Logger.console(3, ['Game Match: Musical Mode'])
	BeatmapManager.send_maps.connect(_on_send_maps)
	Logger.console(3, ['Game Match: Connected the signals to Beatmap Manager'])
	BeatmapManager.play_all_songs()
	spawner = preload("res://scenes/entities/spawner/spawner.tscn")
	start_time = Time.get_ticks_msec()
	Logger.console(3, ['Match has started at', start_time, 'milliseconds.'])

	#var texture = preload("res://assets/Characters/bullet.png")
	#spawner.get_child(0).texture = texture

	var start_game: Timer = Timer.new()
	add_child(start_game)
	start_game.wait_time = countdown_start
	start_game.one_shot = true
	start_game.timeout.connect(_on_start_game_timeout)

	start_game.start()
  
func _on_start_game_timeout():
		if not maps:
				return

		play_next_song()

func play_next_song():
		if maps:
			var current_map	    = maps.pop_back()
			var audio_filename  = current_map[0]
			var notes           = current_map[1]
			is_currently_playing = true
			play_song(audio_filename, notes)

		else:
			print("game end")

func play_song(audio_filename: String, notes: Array):
		Logger.console(3, ["Playing song:", audio_filename])
		for note_data in notes:
			var note = create_note.instantiate()
			add_child(note)
			note.spawn_note.connect(_on_note_spawner_timeout)
	
			var x_y = scale_coordinates(int(note_data['x']), int(note_data['y']))
			var time = (float(note_data['time']) / 1000) - 2
			var type = int(note_data['type'])
			note.create_a_note(x_y, time, type)

		# var audio_resource = ProjectSettings.localize_path(audio_filename)
		var audio = load(audio_filename)
		music.stream = audio
		add_child(music)
		music.play()
		music.finished.connect(_on_music_end)



func _on_send_maps(m):
		maps = m
		maps.shuffle()

func _on_note_spawner_timeout(note):
		spawn.emit(note)

func _on_music_end():
		is_currently_playing = false
		play_next_song()
		

func scale_coordinates(original_x: float, original_y: float) -> Vector2:
		var original_min_x = 0.0
		var original_max_x = 512.0
		var target_min_x = 152.0
		var target_max_x = 1052.0
		
		var original_min_y = 0.0
		var original_max_y = 384.0
		var target_min_y = 64.8
		var target_max_y = 583.2
		# var target_max_y = 648.0
		
		var scaled_x = lerp(target_min_x, target_max_x, inverse_lerp(original_min_x, original_max_x, original_x))
		var scaled_y = lerp(target_min_y, target_max_y, inverse_lerp(original_min_y, original_max_y, original_y))
		
		return Vector2(scaled_x, scaled_y)
