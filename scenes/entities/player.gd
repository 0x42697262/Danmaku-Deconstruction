extends CharacterBody2D

signal gameover(player)
signal touched(body_rid)

@export_category("Properties")
@export var health_points: int  = 3
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

var speed_multiplier = 1.0
var speed = 200

func _ready():
	Logger.console(0, ["Spawned new player", self])
#	$sprite.texture = p3
#	$sprite.texture = [texture_green, texture_red, texture_orange, texture_dead].pick_random()
	hide_mouse(true)
	
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	

func _input(event):
	# Getting the movement of the mouse so the sprite can follow its position.
#	if event is InputEventMouseMotion and is_alive == true:
#		position = event.position
	pass
		
func _process(delta):
	position.x = clamp(position.x, 0, 1152)
	position.y = clamp(position.y, 0, 648)
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		move(delta)

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
	# game over
	if health_points <= 0:
		Logger.console(1, [self, "has died!"])
		is_alive = false
		hide_mouse(false)
		gameover.emit(self)

func move(delta):
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	elif Input.is_action_pressed(&"move_left"):
		velocity.x -= 1

	if Input.is_action_pressed(&"move_focus"):
		speed_multiplier = 0.5
	if Input.is_action_pressed(&"move_dash"):
		speed_multiplier = 2

	if Input.is_action_just_released(&"move_focus"):
		speed_multiplier = 1
	if Input.is_action_just_released(&"move_dash"):
		speed_multiplier = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * speed_multiplier
		
	position += velocity * delta

#	position.x = clamp(position.x, 0, 600)
