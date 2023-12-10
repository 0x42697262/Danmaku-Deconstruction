extends Node2D


signal spawn(star)

var star: PackedScene = preload("res://scenes/entities/spawner/spawner.tscn")
@export var stars_count: int
@export var star_position: Vector2
@export var star_bullet_speed: int
@export var star_bullet_count: int
@export var star_spawn_rate: float
@export var star_remaining_spawns: int
@export var star_vulnerability: bool

func _ready():
	if multiplayer.is_server():
		Logger.console(3, ['Game Match: Endless Mode'])
		$star_spawner.wait_time = 2
		$star_spawner.start()
			

@rpc("authority", "call_local", "reliable")
func spawn_stars():
	if multiplayer.is_server():
		stars_count = randi_range(0, 8)
		star_position           = Vector2(randi_range(0,1052),randi_range(0,548))     
		star_bullet_speed       = randi_range(40,300)                               
		star_bullet_count       = randi_range(8, 24)                                
		star_spawn_rate         = randf_range(0.1, 1)                               
		star_remaining_spawns   = randi_range(1, 10)                                 
		star_vulnerability      = 1*randi_range(0,1)                                   
	
	for i in stars_count:
		var new_star = star.instantiate()
		new_star.global_position    = star_position
		new_star.bullet_speed       = star_bullet_speed
		new_star.number_of_bullets  = star_bullet_count
		new_star.spawn_rate         = star_spawn_rate
		new_star.remaining_spawns   = star_remaining_spawns
		new_star.vulnerable         = star_vulnerability
		
		spawn.emit(new_star)
		
func _on_star_spawner_timeout():
	spawn_stars.rpc()
	$star_spawner.wait_time = randi_range(0, 10)
