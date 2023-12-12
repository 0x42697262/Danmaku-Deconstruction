extends Control

@export var map = GameManager.get_map() as Array
@export var is_playing = false as bool

var hitcircle = preload("res://scenes/entities/spawner/hitcircle.tscn")

func _ready():
	AudioManager.stop()
	AudioManager.finished.connect(_on_finished)

	create_notes()
	$Countdown.start()

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


func _on_finished():
	print('win')
	
func _on_spawn_a_star(star):
	add_child(star)
	
func _on_gameover_signal():
	var scene = load("res://scenes/gameover.tscn").instantiate()
