## Player scene
##
## 

extends Area2D

## Player speed (pixels per second)
@export var speed: int
## Player speed multiplier
##
## Can be used for dash and focus.
##
## Multipliers:
## - Focus: 0.5
## - Normal: 1.0
## - Dash: 2.0
@export var speed_multiplier: float
## Graze collision shape 2d
##
## Used for detecting player collisions against another player.
@export var graze_area: CollisionShape2D
## Player hitbox collision shape 2d
##
## Used for detecting collisions with a bullet.
@export var hitbox: CollisionShape2D

## Player movement
##
## Moves the player based on speed and multiplier
## 
## Left and right movements should be exclusive. Dash takes priority than focus.
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

	position.x = clamp(position.x, 0, 600)
	
## Sets the default values of the scene when it's called.
##
## Adds collision shape children and sprite.
func _ready():
	graze_area = CollisionShape2D.new()
	hitbox = CollisionShape2D.new()
	var graze_area_shape: CircleShape2D	= CircleShape2D.new()
	var hitbox_shape: CircleShape2D	= CircleShape2D.new()
	graze_area_shape.radius	= 14
	hitbox_shape.radius	= 1.5
	graze_area.shape = graze_area_shape
	hitbox.shape = hitbox_shape

	add_child(graze_area)
	add_child(hitbox)
	
	speed = 200
	speed_multiplier = 1.0



## Updates the player every frame.
func _process(delta):
	move(delta)
