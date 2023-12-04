extends Node2D


@export var bullet_scene: PackedScene
@export var min_rotation: int       = 0
@export var max_rotation: int       = 360
@export var number_of_bullets: int  = 8
@export var is_random: bool         = false
@export var is_parent: bool         = false
@export var is_manual: bool         = false
@export var spawn_rate: float       = 0.4
@export var bullet_speed: int       = 5
@export var bullet_lifetime: float  = 10.00
@export var use_velocity: bool      = false # If false use rotation, If true use velocity
@export var rotate_speed: int       = 100
@export var bullet_velocity: Vector2 = Vector2(1,0)

var rotations = []
@export var log_to_console: bool = false

func _ready():
	$Timer.wait_time = spawn_rate
	$Timer.start()
	
func _process(delta):
	var new_rotation = rotation_degrees + rotate_speed * delta
	rotation_degrees = fmod(new_rotation, 360)
	
func random_rotations():
	rotations = []
	for _i in range(0, number_of_bullets):
		rotations.append(randi_range(min_rotation, max_rotation))

func distributed_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		var fraction = float(i) / float(number_of_bullets)
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation + rotation_degrees)

func spawn_bullets():
	if (is_random):
		random_rotations()
	else:
		distributed_rotations()
	
	var spawned_bullets = []
	for i in range(0, number_of_bullets):
		# Instancing
		var bullet = bullet_scene.instantiate()
		
		spawned_bullets.append(bullet)
		
		# Parenting
		if (is_parent):
			add_child(spawned_bullets[i])
		else:
			get_parent().add_child(spawned_bullets[i])
			
		# Apply Fields
		spawned_bullets[i].rotation_degrees = rotations[i]
		spawned_bullets[i].speed            = bullet_speed
		spawned_bullets[i].velocity         = bullet_velocity
		spawned_bullets[i].global_position  = global_position
		spawned_bullets[i].use_velocity     = use_velocity
		spawned_bullets[i].lifetime         = bullet_lifetime
		
		if (log_to_console):
			print("Bullet " + str(i) + " @ " + str(rotations[i]) + "deg")
	
	return spawned_bullets

func _on_timer_timeout(): 
	if !is_manual:
		spawn_bullets()
	
	if (log_to_console):
		print("Spawned Bullets")

