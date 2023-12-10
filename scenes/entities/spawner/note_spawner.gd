extends Timer

signal spawn_note(note)

@onready var spawner: PackedScene = preload("res://scenes/entities/spawner/spawner.tscn")
var note

func create_a_note(coords: Vector2, time: float, type: int):
		wait_time = time + 0.001
		one_shot = true

		var bullets_count = 0
		var vulnerable = true
		var speed = 0
		if type >= 2:
				bullets_count = 8
				vulnerable = false
				speed = 50

				

		note = spawner.instantiate()
		note.supernova_time     = 2.0
		note.vulnerable         = vulnerable
		note.remaining_spawns   = 1
		note.bullet_speed       = randi_range(50, 150) + speed
		note.number_of_bullets  = 8 + bullets_count
		note.spawn_rate         = 0.3
		note.body_rotation      = -45
		note.global_position    = coords

		start()

func _on_timeout():
		if note:
				spawn_note.emit(note)
				queue_free()
