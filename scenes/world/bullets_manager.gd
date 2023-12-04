extends Node2D

const BULLET_COUNT_MAX  = 2500
const SPEED_MIN         = 200
const SPEED_MAX         = 500
const BULLET_IMAGE      = preload("res://assets/Characters/bullet.png")


var bullets: Array[Bullet]      = []
var rids: Dictionary            = {}
@export var difficulty: int     = 0
@export var shape: RID
@onready var spawner: Node      = get_node(^"spawner/spawner")

class Bullet:
	var position: Vector2   = Vector2()
	var speed: float        = 1.0
	var body: RID           = RID()
	var enabled: bool       = false
	var from_bomb: bool     = false

func _ready():
	instantiate_bullets()
	$timer.start()
	
func connect_player(player):
	player.touched.connect(_on_touched_signal)
	print('signal connected! ', player)


func _process(_delta):
	# Order the CanvasItem to update every frame.
	queue_redraw()


func _physics_process(delta):
	spawn_bullet(delta)

# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func _draw():
	var offset = -BULLET_IMAGE.get_size() * 0.5
	for bullet in bullets:
		draw_texture(BULLET_IMAGE, bullet.position + offset)

func _exit_tree():
	clean_up_memory()

func instantiate_bullets():
	shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 8)
	
	for _i in BULLET_COUNT_MAX:
		var bullet: Bullet  = Bullet.new()
		bullet.speed        = SPEED_MIN
		bullet.body         = PhysicsServer2D.body_create()
		rids[bullet.body]   = bullet

		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(bullet.body, shape)
		PhysicsServer2D.body_set_collision_mask(bullet.body, 0)

		spawner.progress    = randi()
		bullet.position     = Vector2(0,0)
		
		var transform2d     = Transform2D()
		transform2d.origin  = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

		bullets.push_back(bullet)

func clean_up_memory():
	for bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)

	PhysicsServer2D.free_rid(shape)
	bullets.clear()

func spawn_bullet(delta):
	var transform2d: Transform2D = Transform2D()
	for bullet in bullets:
		if bullet.enabled == false:
			continue
		
		spawner.progress = randi()
		var vector = Vector2(0, bullet.speed)
		# right side
		if spawner.progress_ratio > 0.25:
			vector = Vector2(-bullet.speed, 0)
		# bottom
		elif spawner.progress_ratio > 0.50:
			vector = Vector2(0, -bullet.speed)
		# left side
		elif spawner.progress_ratio > 0.50:
			vector = Vector2(bullet.speed, 0)
		bullet.position += Vector2(bullet.speed, 0) * delta
			
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
	
func reset_bullet_position(bullet):
		spawner.progress = randi()
		bullet.position = spawner.position
		
func _on_touched_signal(body_rid):
	reset_bullet_position(body_rid)

func _on_timer_timeout():
	if difficulty >= 500:
		$timer.stop()
	bullets[difficulty].enabled = true
	bullets[difficulty].speed += difficulty
	
	#difficulty += 1


func _on_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	reset_bullet_position(rids[body_rid])
	
