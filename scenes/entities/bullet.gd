extends Area2D

@export var speed: int        = 200
@export var lifetime: float   = 10.00
@export var velocity: Vector2 = Vector2()
@export var use_velocity: bool
@export var rotation_change: int = 0
@export var free_on_leave: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(lifetime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
		
	rotation_degrees += rotation_change * delta


func _on_timer_timeout(): 
	queue_free()
 

func _on_body_entered(body): 
	if body.name == "player":
		body.take_damage()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if free_on_leave == true:
		queue_free()
		print('freed')
