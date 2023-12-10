extends Node2D


@export var bullet_scene: PackedScene
## Star's vulnerability to despawn when a player goes inside
@export var vulnerable: bool        = false
@export var is_star: bool           = true
@export var supernova_time: float   = 0.0 # 5s before exploding into supernova
@export var despawn_time: float     = 30.0
@export var min_rotation: int       = 0
@export var max_rotation: int       = 360
@export var number_of_bullets: int  = 8
@export var is_random: bool         = false
@export var is_parent: bool         = false
@export var is_manual: bool         = false
## Interval that bullets spawn
@export var spawn_rate: float       = 0.7
## Remaining amount that the spawner can eject bullets
@export var remaining_spawns: int   = -1
@export var bullet_speed: int       = 100
@export var bullet_lifetime: float  = 10.00
@export var use_velocity: bool      = false # If false use rotation, If true use velocity
## Speed rotation of the spawner
@export var body_rotation: int      = 100
@export var bullet_free_on_leave: bool = true
## Speed rotation of the bullet spawned by the spawner
@export var rotation_change: int 
@export var bullet_velocity: Vector2 = Vector2(1,0)

var rotations = []
@export var log_to_console: bool = false

func _ready():
	if not vulnerable:
		$area/star.modulate = Color.hex(0xff7d00ff)
	
	$Timer.wait_time        = spawn_rate
	$supernova.wait_time    = supernova_time
	$despawn.wait_time      = despawn_time
	if is_star:
		$supernova.start()
	
	Logger.console(0, ['Instantiated', self, "with supernova time of", supernova_time, 
						"seconds -- despawn time", despawn_time, "seconds -- spawn rate of", spawn_rate, "seconds"])
						
func _process(delta):
	var new_rotation = rotation_degrees + body_rotation * delta
	rotation_degrees = fmod(new_rotation, 360)
	
func random_rotations():
	rotations = []
	for _i in range(0, number_of_bullets):
		rotations.append(randi_range(min_rotation, max_rotation))
	Logger.console(-1, [self, "using random rotations with values:", rotations])

func distributed_rotations():
	rotations = []
	for i in range(0, number_of_bullets):
		var fraction = float(i) / float(number_of_bullets)
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation + rotation_degrees)
	
	Logger.console(-1, [self, "using distributed rotations with values:", rotations])

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
		
		# Apply Fields
		spawned_bullets[i].rotation_degrees = rotations[i]
		spawned_bullets[i].speed            = bullet_speed
		spawned_bullets[i].velocity         = bullet_velocity
		spawned_bullets[i].global_position  = global_position
		spawned_bullets[i].use_velocity     = use_velocity
		spawned_bullets[i].lifetime         = bullet_lifetime
		spawned_bullets[i].rotation_change  = rotation_change
		spawned_bullets[i].free_on_leave    = bullet_free_on_leave
		
		# Parenting
		if (is_parent):
			add_child(spawned_bullets[i])
		else:
			get_parent().add_child(spawned_bullets[i])
		if (log_to_console):
			Logger.console(0, ["Bullet", i, "@", rotations[i], "degree"])
	
	return spawned_bullets

func free_memory():
	queue_free()

func _on_timer_timeout():
	if remaining_spawns != 0:
		if !is_manual:
			remaining_spawns -= 1
			spawn_bullets()
	else:
		queue_free()
	
	if (log_to_console):
		Logger.console(0, ['Spawned Bullets'])



func _on_supernova_timeout():
	# play explosion animation
	$area.queue_free()
	$Timer.start()
	$supernova.stop()
	$despawn.start()
	spawn_bullets()
	Logger.console(0, [self, 'has exploded!'])


func _on_despawn_timeout():
	queue_free()
	Logger.console(0, ["Auto despawned", self])


func _on_area_body_entered(body):
	if vulnerable:
	# play some animation here that a star just sparkles
		queue_free()
		Logger.console(0, [body, "entered.", "Safely despawned", self])
	
