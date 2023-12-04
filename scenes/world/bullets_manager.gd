extends Node2D

const BULLET_COUNT_MAX  = 2500
const SPEED_MIN         = 20
const SPEED_MAX         = 500
const BULLET_IMAGE      = preload("res://assets/Characters/bullet.png")


var bullets: Array[Bullet]      = []
var rids: Dictionary            = {}
@export var bullet_count: int   = 1
@export var difficulty: int     = 1 
@export var shape: RID

class Bullet:
	var position: Vector2   = Vector2()
	var speed: float        = 1.0
	var body: RID           = RID()

func _ready():
	instantiate_bullets()

func connect_player(player):
	player.touched.connect(_on_touched_signal)
	print('signal connected! ', player)


func _process(_delta):
	# Order the CanvasItem to update every frame.
	queue_redraw()


func _physics_process(delta):
	var transform2d = Transform2D()
	var offset = get_viewport_rect().size.x + 16
	for bullet in bullets:
		bullet.position.x -= bullet.speed * delta

		if bullet.position.x < -16:
			# Move the bullet back to the right when it left the screen.
			bullet.position.x = offset

		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
	

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

		bullet.position     = Vector2.ZERO
		bullet.position = Vector2(
			randf_range(0, get_viewport_rect().size.x) + get_viewport_rect().size.x,
			randf_range(0, get_viewport_rect().size.y)
		)
		var transform2d     = Transform2D()
		transform2d.origin  = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

		bullets.push_back(bullet)

func clean_up_memory():
	for bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)

	PhysicsServer2D.free_rid(shape)
	bullets.clear()

func _on_touched_signal(body_rid):
	rids[body_rid].position.x = get_viewport_rect().size.x + 16
