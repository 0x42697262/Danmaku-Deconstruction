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


func _ready():
	Logger.console(3, ['Game Match: Musical Mode'])
	BeatmapManager.send_maps.connect(_on_send_maps)
	Logger.console(3, ['Game Match: Connected the signals to Beatmap Manager'])
	BeatmapManager.play_all_songs()
	spawner = preload("res://scenes/entities/spawner/spawner.tscn")
	start_time = Time.get_ticks_msec()
	Logger.console(3, ['Match has started at', start_time, 'milliseconds.'])

	var texture = preload("res://assets/Characters/bullet.png")
	spawner.get_child(0).texture = texture

	var start_game: Timer = Timer.new()
	add_child(start_game)
	start_game.wait_time = countdown_start
	start_game.one_shot = true
	start_game.timeout.connect(_on_start_game_timeout)

	start_game.start()
	for i in maps:
		print(i[0])

  
func _on_start_game_timeout():
		print(Time.get_ticks_msec())

func _on_send_maps(m):
		maps = m
		maps.shuffle()

func spawner_note(x: int, y: int, time: int):
		var timer: Timer  = Timer.new()
		timer.wait_time   = float(time)/1000
		timer.one_shot    = true
# finish the timer and spawn
		var note = spawner.instantiate()
		

		
		
  
"""

[["/home/birb/Github/Danmaku-Deconstruction/Songs/2061853 NewJeans - ETA/audio.mp3", [{ "x": "256", "y": "192", "time": "309", "type": "5" }, { "x": "332", "y": "192", "time": "531", "type": "5" }, { "x": "217", "y": "258", "time": "642", "type": "1" }, { "x": "217", "y": "126", "time": "753", "type": "1" }, { "x": "256", "y": "192", "time": "975", "type": "5" }, { "x": "236", "y": "192", "time": "1197", "type": "5" }, { "x": "265", "y": "208", "time": "1308", "type": "1" }, { "x": "265", "y": "175", "time": "1419", "type": "1" }, { "x": "256", "y": "192", "time": "1642", "type": "5" }, { "x": "256", "y": "192", "time": "2086", "type": "5" }, { "x": "209", "y": "196", "time": "2308", "type": "5" }, { "x": "275", "y": "149", "time": "2420", "type": "1" }, { "x": "282", "y": "230", "time": "2531", "type": "1" }, { "x": "256", "y": "192", "time": "2753", "type": "5" }]], ["/home/birb/Github/Danmaku-Deconstruction/Songs/2061853 NewJeans - ETA/audio.mp3", [{ "x": "76", "y": "28", "time": "309", "type": "6" }, { "x": "63", "y": "76", "time": "753", "type": "2" }, { "x": "23", "y": "156", "time": "1197", "type": "2" }, { "x": "163", "y": "304", "time": "1531", "type": "1" }, { "x": "147", "y": "218", "time": "1642", "type": "6" }, { "x": "171", "y": "144", "time": "1864", "type": "2" }, { "x": "102", "y": "27", "time": "2086", "type": "6" }, { "x": "52", "y": "96", "time": "2308", "type": "1" }, { "x": "192", "y": "133", "time": "2420", "type": "2" }, { "x": "236", "y": "177", "time": "2531", "type": "6" }, { "x": "375", "y": "90", "time": "2753", "type": "2" }, { "x": "41", "y": "102", "time": "2975", "type": "2" }]], ["/home/birb/Github/Danmaku-Deconstruction/Songs/993059 Demetori - Higan Kikou ~ View of The River Styx/audio.mp3", [{ "x": "44", "y": "103", "time": "0", "type": "5" }, { "x": "103", "y": "66", "time": "164", "type": "1" }, { "x": "172", "y": "76", "time": "329", "type": "1" }, { "x": "212", "y": "260", "time": "494", "type": "2" }]]]

"""
