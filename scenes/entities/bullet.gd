extends Area2D

@export var speed: int        = 200
@export var lifetime: float   = 10.00
@export var velocity: Vector2 = Vector2()
@export var use_velocity: bool
@export var rotation_change: int = 0
@export var free_on_leave: bool = false


func _ready():
	Logger.console(-1, ['Instantiated', self])
	$Timer.start(lifetime)
	Logger.console(-1, [self, $Timer, "started with lifetime", lifetime])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
		
	rotation_degrees += rotation_change * delta

func free_memory():
	queue_free()
	# self.monitoring = false
	# self.monitorable = false
	# self.visible = false

func _on_timer_timeout():
	Logger.console(-1, ["Freeing", self, "on _on_timer_timeout"])
	free_memory()
 

func _on_body_entered(body): 
	# if body.name.to_int() in PlayerHPManager.player_health_points:
	body.take_damage()
	Logger.console(0, [self, 'hit', body])
	free_memory()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if free_on_leave == true:
		Logger.console(-1, ["Freeing", self, "on _on_visible_on_screen_notifier_2d_screen_exited"])
		free_memory()
