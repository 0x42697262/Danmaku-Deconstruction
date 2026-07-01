## Beatmap Manager
##
## Purpose is to create a spawner in the map
##
## Star is the Spawner
## Time Sequence is a list of ms time
## Stars is a list of Star (that we can pop_back)
##
## Read an imported beatmap file then use that as patterns.
## Otherwise, randomly spawn the Stars. This is handle through set_beatmap_type
## function.
## 
## Usage:
## Make sure to call `set_beatmap_type(arg)` first. See that function for more info.

extends Node
signal send_maps(maps)

const songs_directory: String = "Songs/"
var dir: DirAccess            = DirAccess.open(".")
var songs_dir: DirAccess

func _ready():
	Logger.console(3, ['Beatmap Manager Started'])
	if "Songs" not in dir.get_directories():
		Logger.console(3, ['Songs directory does not exist. Creating...'])
		dir.make_dir("Songs/")
		if "Songs" in dir.get_directories():
			Logger.console(3, ['Successfully created Songs directory.'])
		else:
			Logger.console(3, ['Fail to create Songs directory.'])
	else:
		songs_dir = DirAccess.open("Songs/")

		play_all_songs()
	
func read_songs_directory():
	if songs_dir:
		Logger.console(3, ["Reading Songs directory..."])
		return songs_dir.get_directories()

func read_song(path: String):
	var song_path = DirAccess.open(songs_directory + path)
	var ddb_files = []
	for song in song_path.get_files():
		if song.to_lower().ends_with('.ddb'):
			ddb_files.append(song)

	var file = FileAccess.open(concat_paths([songs_directory, path, ddb_files[0]]), FileAccess.READ)
	var beatmap = read_osu_file(song_path, file)

	AudioManager.play(beatmap[0])

	return beatmap

func play(map: Array):
	if len(map) < 2:
		return 1
	var audio = map[0]
	AudioManager.play(audio)


	
func get_unconverted_osz_files():
	if songs_dir:
		var osz_files = []
		for song in songs_dir.get_files():
			if song.to_lower().ends_with(".osz"):
				osz_files.append(song)


func read_osu_file(song: DirAccess, osu: FileAccess):
	if !osu:
		return
	if "ddbullet file format v1" not in osu.get_line():
		return

	var metadata: Dictionary  = {
		'General':    {},
		'HitObjects': [],
		'Metadata': {},
		}
	

	var current_metadata: String = ""
	while not osu.eof_reached():
		var line = osu.get_line()
		if "[General]" in line:
			current_metadata = "General"
			continue
		if "[Metadata]" in line:
			current_metadata = "Metadata"
			continue
		if "[HitObjects]" in line:
			current_metadata = "HitObjects"
			continue
		if len(line) < 4:
			current_metadata = ""
			continue

		match current_metadata:
			"General":
				var key_value = line.split(':')
				if len(key_value) == 2:
					metadata["General"][key_value[0]] = key_value[1]

			"Metadata":
				var key_value = line.split(':')
				if len(key_value) == 2:
					metadata["Metadata"][key_value[0]] = key_value[1]

			"HitObjects":
				var raw_data = line.split(',')
				if len(raw_data) >= 4:
					var data = {
							'x'     : raw_data[0],
							'y'     : raw_data[1],
							'time'  : raw_data[2],
							'type'  : raw_data[3],
						}
					metadata['HitObjects'].append(data)

	metadata['General']['AudioFilename'] = concat_paths([song.get_current_dir(), metadata['General']['AudioFilename'].strip_edges()])
	osu.close()

	if "AudioFilename" in metadata["General"] and len(metadata["HitObjects"]) >= 1:
		metadata["General"]["AudioFilename"] = metadata["General"]["AudioFilename"].strip_edges()

		return [metadata["General"]["AudioFilename"], metadata["HitObjects"]]

	return

func play_all_songs():
	if songs_dir:
		var maps: Array = []

		var songs_path: String = songs_dir.get_current_dir()
		var songs = read_songs_directory()
		for song_path in songs:
			var song = DirAccess.open(concat_paths([songs_path, song_path]))
			for osu in song.get_files():
				if osu.to_lower().ends_with(".ddb"):
					var file = FileAccess.open(concat_paths([songs_path,song_path,osu]), FileAccess.READ)
					var map = read_osu_file(song, file)
					if map:
						maps.append(map)

					file.close()

		send_maps.emit(maps)
		Logger.console(3, ["Playing all", len(songs), "songs for match."])

func concat_paths(paths: Array) -> String:
	return "/".join(paths)

# ---- osu! beatmap archive (.osz) import ---- #

## Imports an osu! beatmap archive (.osz) so players can add their own songs.
##
## An .osz is a ZIP archive containing one or more .osu difficulty files plus
## the referenced audio. We extract the beatmap(s) and their audio into a new
## folder under the Songs directory, converting each .osu into the game's .ddb
## format (which is the osu beatmap format with a different header line).
##
## Returns the name of the created song folder, or an empty string on failure.
func import_osz(osz_path: String) -> String:
	var reader = ZIPReader.new()
	if reader.open(osz_path) != OK:
		Logger.console(3, ["[Beatmap Manager] Could not open archive:", osz_path])
		return ""

	var files = reader.get_files()

	# First pass: collect the beatmap files and the audio filenames they use so
	# we only extract the song audio (not hitsound samples, storyboards, etc.).
	var osu_files: Array = []
	var audio_names: Dictionary = {}
	for f in files:
		if f.get_extension().to_lower() == "osu":
			osu_files.append(f)
			var audio = _osu_audio_filename(reader.read_file(f).get_string_from_utf8())
			if audio != "":
				audio_names[audio.to_lower()] = true

	if osu_files.is_empty():
		Logger.console(3, ["[Beatmap Manager] No .osu beatmap found in", osz_path])
		reader.close()
		return ""

	# Build a unique destination folder derived from the archive name.
	var base = DirAccess.open(".")
	if not base.dir_exists(songs_directory):
		base.make_dir(songs_directory)

	var folder_name = _sanitize_filename(osz_path.get_file().get_basename())
	if folder_name.is_empty():
		folder_name = "Imported Beatmap"
	var dest = songs_directory + folder_name
	var suffix = 1
	while base.dir_exists(dest):
		dest = songs_directory + folder_name + " (" + str(suffix) + ")"
		suffix += 1
	base.make_dir_recursive(dest)

	# Extract beatmaps, converting .osu -> .ddb.
	var wrote_beatmap = false
	for f in osu_files:
		var text = reader.read_file(f).get_string_from_utf8()
		var out_file = FileAccess.open(dest + "/" + f.get_file().get_basename() + ".ddb", FileAccess.WRITE)
		if out_file:
			out_file.store_string(_convert_osu_to_ddb(text))
			out_file.close()
			wrote_beatmap = true

	# Extract only the audio referenced by the beatmaps.
	var wrote_audio = false
	for f in files:
		if audio_names.has(f.get_file().to_lower()):
			var out_file = FileAccess.open(dest + "/" + f.get_file(), FileAccess.WRITE)
			if out_file:
				out_file.store_buffer(reader.read_file(f))
				out_file.close()
				wrote_audio = true

	reader.close()

	if not wrote_beatmap:
		Logger.console(3, ["[Beatmap Manager] Failed to write beatmap from", osz_path])
		return ""
	if not wrote_audio:
		Logger.console(3, ["[Beatmap Manager] Warning: no audio extracted from", osz_path])

	# Refresh the cached Songs directory handle so the new folder is listed.
	songs_dir = DirAccess.open(songs_directory)
	Logger.console(3, ["[Beatmap Manager] Imported beatmap into", dest])
	return dest.get_file()

## Reads the AudioFilename entry from raw .osu file text.
func _osu_audio_filename(text: String) -> String:
	for line in text.split("\n"):
		if line.begins_with("AudioFilename"):
			var key_value = line.split(":")
			if key_value.size() >= 2:
				return key_value[1].strip_edges()
	return ""

## Converts osu beatmap text into the game's .ddb format. The only structural
## difference is the first line, so we swap the header and normalise the CRLF
## line endings osu files ship with.
func _convert_osu_to_ddb(text: String) -> String:
	var lines = text.split("\n")
	var out = "ddbullet file format v1\n"
	for i in range(1, lines.size()):
		out += lines[i].trim_suffix("\r") + "\n"
	return out

## Strips characters that are not valid in folder names across platforms.
func _sanitize_filename(name: String) -> String:
	for c in ["/", "\\", ":", "*", "?", "\"", "<", ">", "|"]:
		name = name.replace(c, "")
	return name.strip_edges()
