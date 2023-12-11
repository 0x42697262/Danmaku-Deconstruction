extends CharacterBody2D

@export var is_alive        = true as bool
@export var health_points   = 30 as int

func _ready():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())
		Logger.console(0, ["Set", self, "Multiplayer Authority to", name])
		$sprite.texture = TextureManager.get_planet(randi_range(1,8))
		hide_mouse(true)
	
func _input(event):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		# Getting the movement of the mouse so the sprite can follow its position.
		if event is InputEventMouseMotion and is_alive:
			position = event.position

func _process(delta):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		position.x = clamp(position.x, 0, 1152)
		position.y = clamp(position.y, 0, 648)
#
func hide_mouse(value: bool):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		if value == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Logger.console(0, [self, "mouse cursor set to HIDDEN"])
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Logger.console(0, [self, "mouse cursor set to VISIBLE"])

func take_damage(damage: int = 10):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		self.health_points -= damage
	if self.health_points <= 0:
		hide_mouse(false)
		self.is_alive = false
		Logger.console(3, ["Player", self.name, "has died!"])
		queue_free()

func heal(hp: int = 1):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		self.health_points += hp
		Logger.console(1, ["Increased HP for", self.name, "New HP:", self.health_points])

  
#func explode():
		#var explode = preload("res://scenes/entities/spawner/spawner.tscn").instantiate()
		#explode.vulnerable = false
		#explode.supernova_time = 0
		#explode.number_of_bullets = 64
		#explode.remaining_spawns = 1
		#explode.bullet_speed = 150
		#explode.body_rotation = 0
		#explode.spawn_rate = 0
		#explode.global_position = position
		#explode.is_star = false
		#explode.get_child(0).queue_free()
		##get_parent().add_child(explode)
		#spawn.emit(explode)
		#explode.spawn_bullets()
#
		#queue_free()
