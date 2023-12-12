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
		if "" in line:
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
