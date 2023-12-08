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

var beatmap_type: String = ""

var Stars: Array[Star]          = []
var time_sequence: Array[float] = []

class Star:
	var position: Vector2
	# kind of spawner

class PatternSequence:
	var time: Array[float]

func _ready():
	Logger.console(3, ['Beatmap Manager Started'])


func set_beatmap_type(type: String):
	Logger.console(3, ["Configured Beatmap Manager type to", type, "mode"])
	match type:
		"endless":
			pass
		"osz":
			print("osz")

func reset_beatmap_manager():
	beatmap_type    = ""
	Stars           = []
	time_sequence   = []
	Logger.console(3, ["Cleared Beatmap Manager memory."])
