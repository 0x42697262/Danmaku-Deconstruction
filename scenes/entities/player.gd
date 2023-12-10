extends CharacterBody2D

signal gameover(player)
signal touched(body_rid)

@export_category("Properties")
@export var health_points: int  = 10
@export var is_alive: bool      = true

var texture_red: Texture    = preload("res://assets/Characters/red_character.png")
var texture_orange: Texture = preload("res://assets/Characters/orange_character.png")
var texture_green: Texture  = preload("res://assets/Characters/green_character.png")
var texture_dead: Texture  = preload("res://assets/Characters/gray_character.png")


func _ready():
	Logger.console(0, ["Spawned new player", self])
	$sprite.texture = [texture_green, texture_red, texture_orange, texture_dead].pick_random()
	hide_mouse(true)
	

func _input(event):
	# Getting the movement of the mouse so the sprite can follow its position.
	if event is InputEventMouseMotion and is_alive == true:
		position = event.position
		
func _process(delta):
	position.x = clamp(position.x, 0, 1152)
	position.y = clamp(position.y, 0, 648)

func hide_mouse(value: bool):
	if value == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Logger.console(0, [self, "mouse cursor set to HIDDEN"])
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Logger.console(0, [self, "mouse cursor set to VISIBLE"])

func take_damage():
	if is_alive == true:
		Logger.console(1, [self, "has taken damage."])
		health_points -= 1
		match health_points:
			1:
				$sprite.texture = texture_red
			2:
				$sprite.texture = texture_orange
			0:
				gameover.emit(self)
			_:
				$sprite.texture = texture_green
	# game over
	if health_points <= 0:
		Logger.console(1, [self, "has died!"])
		is_alive = false
		hide_mouse(false)
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
