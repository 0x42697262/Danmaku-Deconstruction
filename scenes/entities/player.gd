## Player scene
##
## 
extends Area2D

## Player speed (pixels per second)
@export var speed: float = 300.0
## Player speed multiplier
##
## Can be used for dash and focus.
##
## Multipliers:
## - Focus: 0.5
## - Normal: 1.0
## - Dash: 4.0
@export var SPEED_MULTIPLIER: float = 1.0
@export var DASH_MULTIPLIER: float = 4.0
@export var FOCUS_MULTIPLIER: float = 0.5
## Graze collision shape 2d
##
## Used for detecting player collisions against another player.
var graze_area: CollisionShape2D
## Player hitbox collision shape 2d
##
## Used for detecting collisions with a bullet.
var hitbox: CollisionShape2D
## Polygon body circle
var body: Polygon2D
var body_sprite: Sprite2D

## Player settings
##
## Allow to be change in multiplayer
@export_group("Settings")
## Player ID
@export var id: int = 0
## Player radius
@export var body_radius: int = 14
## Hitbox radius
@export var hitbox_radius: float = 3
## Map Area
@export var area_min: Vector2 = Vector2.ZERO
@export var area_max: Vector2 = Vector2(800, 598)

## Player movement
##
## Moves the player based on speed and multiplier
## 
## Left and right movements should be exclusive. Dash takes priority than focus.
func move(delta):
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed(&"ui_down"):
		velocity.y += 1

	if Input.is_action_pressed(&"move_focus"):
		SPEED_MULTIPLIER = FOCUS_MULTIPLIER
	if Input.is_action_pressed(&"move_dash"):
		SPEED_MULTIPLIER = DASH_MULTIPLIER

	if Input.is_action_just_released(&"move_focus"):
		SPEED_MULTIPLIER = 1
	if Input.is_action_just_released(&"move_dash"):
		SPEED_MULTIPLIER = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * SPEED_MULTIPLIER
		
	position += velocity * delta

	position.x = clamp(position.x, area_min.x, area_max.x)
	position.y = clamp(position.y, area_min.y, area_max.y)
	
## Sets the default values of the scene when it's called.
##
## Adds collision shape children and sprite.
func _ready():
	# add collisions
	graze_area = CollisionShape2D.new()
	hitbox = CollisionShape2D.new()
	var graze_area_shape: CircleShape2D	= CircleShape2D.new()
	var hitbox_shape: CircleShape2D	= CircleShape2D.new()
	graze_area_shape.radius	= body_radius
	hitbox_shape.radius	= hitbox_radius
	graze_area.shape = graze_area_shape
	hitbox.shape = hitbox_shape

	add_child(graze_area)
	add_child(hitbox)

	body_sprite = Sprite2D.new()
	var texture: Texture = preload("res://assets/Characters/gray_character.png")
	body_sprite.texture = texture
	body_sprite.scale = Vector2(body_radius*2+5,body_radius*2+5) / texture.get_size()
	
	area_min.x += body_radius+1
	area_min.y += body_radius+1
	area_max.x -= body_radius+1
	area_max.y -= body_radius+1

	add_child(body_sprite)
	
func set_sprite_texture(texture: Texture):
	body_sprite.texture = texture

## Updates the player every frame.
func _process(delta):
	move(delta)
