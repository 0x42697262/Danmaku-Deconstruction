extends Node2D


signal spawn(star)

var star: PackedScene = preload("res://scenes/entities/spawner/spawner.tscn")


func _ready():
	Logger.console(3, ['Game Match: Endless Mode'])
	$star_spawner.wait_time = 2
	$star_spawner.start()
			

func _on_star_spawner_timeout():
	var stars_count: int = randi_range(0, 4)
	for i in stars_count:
		var new_star = star.instantiate()
		new_star.global_position    = Vector2(randi_range(0,1052),randi_range(0,548))
		new_star.bullet_speed       = randi_range(40,300)
		new_star.number_of_bullets  = randi_range(8, 24)
		new_star.spawn_rate         = randi_range(0.1, 1)
		new_star.remaining_spawns   = randi_range(1, 10)
		new_star.vulnerable         = 1*randi_range(0,1)
		
		spawn.emit(new_star)
		
	$star_spawner.wait_time = randi_range(0, 10)
