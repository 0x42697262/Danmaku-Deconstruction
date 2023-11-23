extends Area2D
@export var speed = 200 # How fast the player will move (pixels/sec).
@export var speed_multiplier = 1

var screen_size # Size of the game window.
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"ui_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_slow"):
		speed_multiplier = 0.5
	if Input.is_action_pressed(&"move_dash"):
		speed_multiplier = 2
	if Input.is_action_just_released(&"move_slow"):
		speed_multiplier = 1
	if Input.is_action_just_released(&"move_dash"):
		speed_multiplier = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * speed_multiplier

	position += velocity * delta
#	position = position.clamp(Vector2.ZERO, screen_size)
