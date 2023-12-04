extends Area2D

## Player speed (pixels per second)
@export var SPEED: float = 300.0
## Player speed multiplier
##
## Can be used for dash and focus.
##
## Multipliers:
## - Focus: 0.5
## - Normal: 1.0
## - Dash: 4.0
@export var SPEED_MULTIPLIER: float = 1.0
@export var DASH_MULTIPLIER: float  = 4.0
@export var FOCUS_MULTIPLIER: float = 0.5
@export var Y_AXIS: int             = 1
@export var velocity: Vector2 = Vector2.ZERO
@export var area_min = Vector2(0, 0)
@export var area_max = Vector2(800, 598)

var id: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

## Player movement
##
## Moves the player based on speed and multiplier
## 
## Left and right movements should be exclusive. Dash takes priority than focus.
func move(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1 * Y_AXIS
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1  * Y_AXIS

	if Input.is_action_pressed(&"move_focus"):
		SPEED_MULTIPLIER = FOCUS_MULTIPLIER
	if Input.is_action_pressed(&"move_dash"):
		SPEED_MULTIPLIER = DASH_MULTIPLIER

	if Input.is_action_just_released(&"move_focus"):
		SPEED_MULTIPLIER = 1
	if Input.is_action_just_released(&"move_dash"):
		SPEED_MULTIPLIER = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED * SPEED_MULTIPLIER
		
	position += velocity * delta

	position.x = clamp(position.x, area_min.x + 14, area_max.x - 14)
	position.y = clamp(position.y, area_min.y + 14, area_max.y - 14)
