extends Node

signal started()
signal stopped()
signal finished()

@export var is_currently_playing  = false as bool
@export var current_music         = "" as String
@export var music                 = AudioStreamPlayer.new() as AudioStreamPlayer



func _ready():
	add_child(music)
	# Route game music through the "Music" bus so the in-game Music volume
	# slider actually controls it (issue #46).
	if AudioServer.get_bus_index("Music") != -1:
		music.bus = "Music"
	music.finished.connect(_on_music_finished)

func play(audio_path: String):
	var stream = _load_stream(audio_path)
	if stream == null:
		GameLogger.console(3, ["[Audio Manager] Failed to load audio:", audio_path])
		return
	music.stream = stream
	music.play()
	started.emit()
	self.is_currently_playing = true
	self.current_music = audio_path

	GameLogger.console(3, ["[Audio Manager] Currently playing:", self.current_music])

## Loads an audio stream, supporting user-supplied songs that were never
## imported by the editor. Godot's load() only works on imported resources, so
## files dropped into the Songs directory at runtime fail (issue #61). Here we
## fall back to reading the raw bytes off disk and building the stream manually.
func _load_stream(audio_path: String) -> AudioStream:
	# Prefer already-imported project resources when they exist.
	if ResourceLoader.exists(audio_path):
		var res = load(audio_path)
		if res is AudioStream:
			return res

	var path = audio_path
	if not FileAccess.file_exists(path):
		path = ProjectSettings.globalize_path(audio_path)
	if not FileAccess.file_exists(path):
		return null

	var bytes = FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		return null

	match path.get_extension().to_lower():
		"mp3":
			var mp3 = AudioStreamMP3.new()
			mp3.data = bytes
			return mp3
		"ogg", "oga":
			return AudioStreamOggVorbis.load_from_buffer(bytes)

	GameLogger.console(3, ["[Audio Manager] Unsupported audio format:", path])
	return null

	
func stop():
	music.stop()
	stopped.emit()
	GameLogger.console(3, ["[Audio Manager] Stopped:", self.current_music])

func _on_music_finished():
	finished.emit()
