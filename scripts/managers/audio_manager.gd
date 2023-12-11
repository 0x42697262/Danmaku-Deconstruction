extends Node


@export var is_currently_playing  = false as bool
@export var current_music         = "" as String
@export var music                 = AudioStreamPlayer.new() as AudioStreamPlayer


func _ready():
	add_child(music)

func play(audio_path: String):
	var audio = ProjectSettings.localize_path(audio_path)
	music.stream = load(audio)
	music.play()
	self.is_currently_playing = true
	self.current_music = audio

	Logger.console(3, ["[Audio Manager] Currently playing:", self.current_music])

	
func stop():
	music.stop()
	Logger.console(3, ["[Audio Manager] Stopped:", self.current_music])
