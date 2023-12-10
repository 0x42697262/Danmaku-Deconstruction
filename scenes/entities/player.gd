extends CharacterBody2D

signal gameover(player)
signal touched(body_rid)

@export_category("Properties")
@export var health_points: int  = 30
@export var is_alive: bool      = true

#var texture_red: Texture    = preload("res://assets/Characters/red_character.png")
#var texture_orange: Texture = preload("res://assets/Characters/orange_character.png")
#var texture_green: Texture  = preload("res://assets/Characters/green_character.png")
#var texture_dead: Texture  = preload("res://assets/Characters/gray_character.png")

var p1: Texture = preload("res://assets/Characters/mercury.png")
var p2: Texture = preload("res://assets/Characters/venus.png")
var p3: Texture = preload("res://assets/Characters/earth.png")
var p4: Texture = preload("res://assets/Characters/mars.png")
var p5: Texture = preload("res://assets/Characters/jupiter.png")
var p6: Texture = preload("res://assets/Characters/saturn.png")
var p7: Texture = preload("res://assets/Characters/uranus.png")
var p8: Texture = preload("res://assets/Characters/neptune.png")

var player_texture = [p1, p2, p3, p4, p5, p6, p7, p8]

func _ready():
	Logger.console(0, ["Spawned new player", self])
	hide_mouse(true)
	
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	

func _input(event):
	# Getting the movement of the mouse so the sprite can follow its position.
	if event is InputEventMouseMotion and is_alive == true:
		position = event.position
		
func _process(delta):
	position.x = clamp(position.x, 0, 1152)
	position.y = clamp(position.y, 0, 648)
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		pass

func hide_mouse(value: bool):
	if value == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Logger.console(0, [self, "mouse cursor set to HIDDEN"])
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Logger.console(0, [self, "mouse cursor set to VISIBLE"])

func take_damage():
	if is_alive == true:
		Logger.console(1, [self, "has taken damage. Current HP:", health_points])
		health_points -= 10
	# game over
	if health_points <= 0:
		Logger.console(1, [self, "has died!"])
		is_alive = false
		hide_mouse(false)
		gameover.emit(self)
		explode()

func explode():
		var explode = preload("res://scenes/entities/spawner/spawner.tscn").instantiate()
		explode.vulnerable = false
		explode.supernova_time = 0
		explode.number_of_bullets = 64
		explode.remaining_spawns = 1
		explode.bullet_speed = 150
		explode.body_rotation = 0
		explode.spawn_rate = 0
		explode.global_position = position
		explode.is_star = false
		explode.get_child(0).queue_free()
		get_parent().add_child(explode)
		explode.spawn_bullets()

		queue_free()
