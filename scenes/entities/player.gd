extends CharacterBody2D

signal died(explode)
signal gameover
signal health_changed(current_hp)

@export var is_alive        = true as bool
@export var health_points   = 30 as int

func _ready():
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())
		Logger.console(0, ["[Game Manager] Set", self, "Multiplayer Authority to", name])
		$sprite.texture = TextureManager.get_planet(randi_range(1,8))
		GameManager.hide_mouse(true)
	
func _input(event):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		# Getting the movement of the mouse so the sprite can follow its position.
		if event is InputEventMouseMotion and is_alive:
			position = event.position

func _process(delta):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		position.x = clamp(position.x, 0, 1152)
		position.y = clamp(position.y, 0, 648)

func take_damage(damage: int = 3):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		self.health_points -= damage
		clamp(self.health_points, 0, 1000)
		Logger.console(1, ["Decreased HP for", self.name, "New HP:", self.health_points])
		health_changed.emit(self.health_points)
	if self.health_points <= 0:
		dead.rpc()
		gameover.emit()

func heal(hp: int = 1):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		self.health_points += hp
		clamp(self.health_points, 0, 1000)
		Logger.console(1, ["Increased HP for", self.name, "New HP:", self.health_points])
		health_changed.emit(self.health_points)

@rpc("any_peer", "call_local")
func dead():
	is_alive = false
	explode()
	queue_free()

	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		GameManager.hide_mouse(false)
  
func explode():
		var explosion = preload("res://scenes/entities/spawner/spawner.tscn").instantiate()
		explosion.vulnerable        = false
		explosion.supernova_time    = 0
		explosion.number_of_bullets = 24
		explosion.remaining_spawns  = 2
		explosion.bullet_speed      = 150
		explosion.body_rotation     = 0
		explosion.spawn_rate        = 0.2
		explosion.global_position   = position
		explosion.is_star           = false

		died.emit(explosion)
		explosion.custom_spawn_bullets()
